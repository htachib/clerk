module Parsers
  class KeheNewItemSetup < Base
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
        invoice_num = invoice_num_rows.first.gsub(/invoice.*#/i,'').strip

        invoice_num.empty? ? alt_invoice_num(meta_data, invoice_num_rows.last) : invoice_num
      end

      def alt_invoice_num(meta_data, invoice_row)
        idx = meta_data.index(invoice_row) + 1
        meta_data[idx].split(' ').last
      end

      def parsed_meta_data(document)
        parsed = {}
        meta_data = get_raw_data(document,'meta_data').map do |row|
          row.join(' ')
        end

        parsed['invoice number'] = invoice_num_from_file_name(document) || invoice_num(meta_data)

        type_row = meta_data.select{|row| row.match(/type.*:?/i) }.first
        parsed['Type'] = type_row.gsub(/type:?/i,'').strip
        parsed
      end

      def parsed_invoice_date(document)
        invoice_date_row = get_raw_data(document, 'invoice_date')
        date = invoice_date_row ? invoice_date_row.flatten[0] : invoice_date_from_file_name(document)
        {'invoice_date' => date}
      end

      def parsed_totals(document)
        totals = get_raw_data(document, 'totals').flatten
        invoice_total_row = totals.select{ |row| row.match(/$/)}.last
        invoice_total = get_amount_str(invoice_total_row)
        chargeback_amount = str_to_dollars(invoice_total)

        {'chargeback_amount' => chargeback_amount}
      end
    end
  end
end
