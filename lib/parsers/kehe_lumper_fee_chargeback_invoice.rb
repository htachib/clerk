module Parsers
  class KeheLumperFeeChargebackInvoice < Base
    class << self
      def parse_rows(document)
        invoice_data(document).deep_merge(
        'file_name' => document['file_name']
        ).deep_merge(
        'uploaded_at' => document['uploaded_at']
        )
      end

      def invoice_data(document)
        parsed_meta_data(document).deep_merge(parsed_invoice_date(document)
        ).deep_merge(parsed_totals(document))
      end

      def get_raw_data(document, type)
        document[type].map {|row| row.values }
      end

      def invoice_num(meta_data)
        invoice_num_rows = meta_data.select{|row| row.match(/invoice.*#/i) }
        invoice_num_rows ? invoice_num_rows.first.gsub(/invoice.*#/i,'').strip : nil
      end

      def parsed_meta_data(document)
        parsed = {}
        meta_data = get_raw_data(document,'meta_data').map do |row|
          row.join(' ')
        end

        parsed['invoice number'] = invoice_num_from_file_name(document) || invoice_num(meta_data)
        type_row = meta_data.select{|row| row.match(/type.*:?/i) }.first
        parsed['Type'] = type_row.gsub(/type\W?/i,'').strip
        parsed
      end

      def parsed_invoice_date(document)
        invoice_date_row = get_raw_data(document, 'invoice_date')
        date = invoice_date_row ? invoice_date_row.flatten[0] : invoice_date_from_file_name(document)
        {'invoice_date' => date}
      end

      def calc_grand_total(one, two)
        one && two ? one + two : nil
      end

      def parsed_totals(document)
        totals = get_raw_data(document, 'totals').flatten
        subtotal = totals.select{|row| row.match(/(promo|chargeback)/i) }.first
        subtotal_str = get_amount_str(subtotal)
        subtotal_in_dollars = str_to_dollars(subtotal_str)

        ep_fee = totals.select{|row| row.match(/ep.*fee/i) }.first
        ep_fee_str = get_amount_str(ep_fee)
        ep_fee_in_dollars = str_to_dollars(ep_fee_str)

        grand_total = totals.select{|row| row.match(/invoice.*total/i) }.first
        grand_total_str = get_amount_str(grand_total)
        grand_total_in_dollars = str_to_dollars(grand_total_str)

        chargeback_amount = grand_total_in_dollars ||
                            calc_grand_total(subtotal_in_dollars, ep_fee_in_dollars)

        {'chargeback_amount' => chargeback_amount,
          'ep_fee' => ep_fee_in_dollars}
      end
    end
  end
end
