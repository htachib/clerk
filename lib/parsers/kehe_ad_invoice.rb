module Parsers
  class KeheAdInvoice < Base
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

      def invoice_num(meta_data)
        invoice_num_rows = meta_data.select{|row| row.match?(/invoice.*#/i) }
        invoice_num = invoice_num_rows.first.to_s.gsub(/invoice.*#/i,'').strip
        invoice_num.empty? ? alt_invoice_num(meta_data, invoice_num_rows.last) : invoice_num
      end

      def alt_invoice_num(meta_data, invoice_row)
        idx = meta_data.index(invoice_row) + 1
        idx ? meta_data[idx].split(' ').last : nil
      end

      def parsed_meta_data(document)
        parsed = {}
        meta_data = get_raw_data(document,'meta_data').map do |row|
          row.join(' ')
        end

        parsed['invoice number'] = invoice_num_from_file_name(document) || invoice_num(meta_data)

        type_row = string_match_from_arr(meta_data, /type.*:?/i)
        parsed['Type'] = type_row.to_s.gsub(/type:?/i,'').strip
        
        parsed
      end

      def parsed_invoice_date(document)
        invoice_date_row = get_raw_data(document, 'invoice_date')
        date = invoice_date_row ? invoice_date_row.try(:flatten).try(:first) : invoice_date_from_file_name(document)
        {'invoice_date' => date}
      end

      def parsed_totals(document)
        totals = get_raw_data(document, 'totals').try(:flatten) || []
        invoice_total_row = string_match_from_arr(totals, /invoice.*total/i)
        chargeback_str = string_match(invoice_total_row, /\$\d+\.?\d+/)
        chargeback_amount = str_to_dollars(chargeback_str)

        ep_fee_row = string_match_from_arr(totals, /ep.*fee/i)
        ep_fee_str = string_match(ep_fee_row, /\$\d+\.?\d+/)
        ep_fee_amount = str_to_dollars(ep_fee_str)

        {'chargeback_amount' => chargeback_amount,
          'ep_fee' => ep_fee_amount}
      end
    end
  end
end
