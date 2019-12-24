module Parsers
  module Helpers
    module KeheSanitizers
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

      def invoice_rows(meta_data, row_regex)
        meta_data.select{ |row| row.match?(row_regex) }
      end

      # def get_invoice_number(invoice_rows, str_regex)
      #   invoice_rows.first.to_s.try(:gsub,str_regex,'').strip
      # end

      def sanitize_invoice_num(meta_data, row_regex, str_regex)
        invoice_rows = invoice_rows(meta_data, row_regex)
        invoice_number = get_invoice_number(invoice_rows, str_regex)
        invoice_number.empty? ? alt_invoice_number(meta_data, invoice_rows.last) : invoice_number
      end

      def alt_invoice_number(meta_data, invoice_row, alt_idx = 1)
        idx = meta_data.index(invoice_row) + alt_idx
        idx ? meta_data[idx].split(' ').last : nil
      end
    end
  end
end
