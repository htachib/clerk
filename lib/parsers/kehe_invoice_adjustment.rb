module Parsers
  class KeheInvoiceAdjustment < Base
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
        invoice_num_rows = meta_data.select{|row| row.match(/invoice.*number/i) }
        invoice_num = invoice_num_rows.first.gsub(/invoice.*number.*:/i,'').strip
      end

      def parsed_meta_data(document)
        parsed = {}
        meta_data = get_raw_data(document,'meta_data').map do |row|
          row.join(' ')
        end

        parsed['invoice number'] = invoice_num(meta_data)
        parsed
      end

      def parsed_invoice_date(document)
        date = get_raw_data(document, 'invoice_date').flatten[0]
        {'invoice_date' => date}
      end

      def parsed_totals(document)
        chargeback_amount = get_raw_data(document, 'totals').flatten.first
        {'chargeback_amount' => chargeback_amount}
      end
    end
  end
end
