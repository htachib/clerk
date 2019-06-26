module Parsers
  class KeheScanInvoice < Base
    class << self
      include Parsers::Helpers::KeheSanitizers
      
      def parse_rows(document)
        invoice_data(document).deep_merge(
        'file_name' => document['file_name']
        ).deep_merge(
        'uploaded_at' => document['uploaded_at']
        )
      end

      def invoice_data(document)
        parsed_meta_data(document).deep_merge(parsed_invoice_date(document)
        ).deep_merge(parsed_totals(document)
        ).deep_merge(parsed_customer(document))
      end

      def get_raw_data(document, type)
        return nil if !document[type]
        document[type].map { |row| row.values }
      end

      def invoice_num(meta_data)
        invoice_num_rows = meta_data.select{|row| row.match(/invoice.*#/i) }
        invoice_num = invoice_num_rows.first.gsub(/invoice.*#/i,'').strip
        invoice_num.empty? ? alt_invoice_num(meta_data, invoice_num_rows.last) : invoice_num
      end

      def alt_invoice_num(meta_data, invoice_row)
        idx = meta_data.index(invoice_row) + 1
        meta_data[idx].split(' ').last
      end

      def customer_row_idx(rows)
        rows.find_index{|row| row.match?(/(phone|fax)/i)} + 1
      end

      def sanitized_customer(rows)
        customer_row = rows.last
        if customer_row.match?(/(chargeback.*invoice)/i)
          idx = customer_row_idx(rows)
          row = rows[idx]
          customer_row = row.match?(/chargeback.*invoice/i) ? 'KeHE' : row
        end

        regex = /(date|\#|scans|scan|chargeback|invoice|reclamation|recovery|date.*invoice$)/i
        customer_row.gsub(regex,'').strip
      end

      def parsed_customer(document)
        rows = get_raw_data(document, 'customer').flatten
        customer = sanitized_customer(rows)
        {'detailed_customer' => customer}
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

      def parsed_totals(document)
        totals = get_raw_data(document, 'totals').flatten
        invoice_total_row = totals.last
        invoice_total = get_amount_str(invoice_total_row)
        total_in_dollars = str_to_dollars(invoice_total)

        ep_fee = totals.select{|row| row.match(/ep.*fee/i) }.first
        ep_fee_str = get_amount_str(ep_fee)
        ep_fee_in_dollars = str_to_dollars(ep_fee_str)

        {'chargeback_amount' => total_in_dollars,
          'ep_fee' => ep_fee_in_dollars}
      end
    end
  end
end
