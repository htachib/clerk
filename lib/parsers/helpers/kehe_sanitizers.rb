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

      def get_invoice_number(invoice_rows, str_regex)
        invoice_rows.first.to_s.try(:gsub,str_regex,'').strip
      end

      def sanitize_invoice_num(meta_data, row_regex, str_regex)
        invoice_rows = invoice_rows(meta_data, row_regex)
        invoice_number = get_invoice_number(invoice_rows, str_regex)
        invoice_number.empty? ? alt_invoice_number(meta_data, invoice_rows.last) : invoice_number
      end

      def alt_invoice_number(meta_data, invoice_row, alt_idx = 1)
        idx = meta_data.index(invoice_row) + alt_idx
        idx ? meta_data[idx].split(' ').last : nil
      end

      def get_meta_data(document)
        get_raw_data(document,'meta_data').map { |row| row.join(' ') }
      end

      def get_totals(document)
        get_raw_data(document, 'totals').try(:flatten) || []
      end

      def get_customer_data(document)
        get_raw_data(document, 'customer').try(:flatten) || []
      end

      def get_total_in_dollars(amounts_arr, regex)
        amount_row = string_match_from_arr(amounts_arr, regex)
        amount_str = string_match(amount_row, /\$\d+(\.|\s)?\d+/)
        str_to_dollars(amount_str)
      end

      def get_invoice_date(row, document)
        date = row.try(:flatten).try(:first)
        date ? date : invoice_date_from_file_name(document)
      end

      def titleize_with_spaces(string)
        return string if string.try(:match?, /[A-Z]{3}/)
        result = ''
        no_whitespace = string.try(:scan,/\S+/).try(:join,'')
        no_whitespace.try(:split, '').each do |ch|
          ch = ' ' + ch if ch.match?(/([A-Z]|\/)/)
          result += ch
        end
        result.try(:strip)
      end

      def date_formatted_promo(year, month, day = 1)
        return nil unless (year && month)
        DateTime.new(year.to_i, [month.to_i, 12].min, [day.to_i, 31].min).strftime("%m/%d/%y")
      end
    end
  end
end
