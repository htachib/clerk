module Parsers
  class DpiMcb < Base
    class << self
      def parse_rows(document)
        rows = []
        row_count = document.try(:[], 'invoice_date').count

        row_count.times do |row_idx|
          meta_data = parsed_meta_data(document)
          row_data = invoice_data(document, meta_data, row_idx)
          rows.push(row_data)
        end
        rows
      end

      def parsed_meta_data(document)
        parsed_invoice_number(document
        ).deep_merge('uploaded_at' => document['uploaded_at']
        ).deep_merge('file_name' => document['file_name'])
      end

      def invoice_data(document, meta_data, row_idx)
        meta_data.deep_merge(
        parsed_invoice_date(document, row_idx)).deep_merge(
        parsed_customer_chain(document)).deep_merge(
        parsed_upc(document, row_idx)).deep_merge(
        parsed_item_description(document, row_idx)).deep_merge(
        parsed_customer_location(document, row_idx)).deep_merge(
        parsed_shipped(document, row_idx)).deep_merge(
        parsed_contract_type(document)).deep_merge(
        parsed_totals(document, row_idx))
      end

      def parsed_invoice_number(document)
        invoice_number = get_invoice_number(document)
        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_date(document, row_idx)
        invoice_dates = document.try(:[], 'invoice_date').try(:[], row_idx)
        dates = invoice_dates.try(:values).try(:first).try(:scan, /\d{2}\/\d{2}\/\d{4}/)
        start_date = dates.try(:[], -2)
        end_date = dates.try(:[], -1)

        {
          'start_date' => start_date,
          'end_date' => end_date
        }
      end

      def line_items(document)
        line_items = document.try(:[], 'line_items').map{|line| line.try(:values).try(:first)}
        merged_line_items = []
        skip = false
        line_items.each_with_index do |line, idx|
          line = line.try(:gsub, /\W+$/, '').try(:strip)
          if skip
            skip = false
            next
          elsif line.try(:match?, /\d+(\.|\,)\d+$/)
            merged_line_items.push(line)
          else
            line = line + line_items.try(:[], idx + 1)
            merged_line_items.push(line)
            skip = true
          end
        end
        merged_line_items
      end

      def get_line_item(document, row_idx)
        line_items(document).try(:[], row_idx)
      end

      def parsed_digits(document, row_idx)
        values = row_values(document, row_idx)
        values.try(:scan, /\d+\.?\d*/)
      end

      def row_values(document, row_idx) # merges and sanitizes rows
        get_line_item(document, row_idx)
      end

      def parsed_totals(document, row_idx)
        chargeback_amount = parsed_digits(document, row_idx).try(:last)
        { 'chargeback_amount' => str_to_dollars(chargeback_amount) }
      end

      def parsed_upc(document, row_idx)
        values = row_values(document, row_idx)
        upc = values.try(:scan, /\d{8,}/).try(:last)
        { 'upc' => upc }
      end

      def parsed_item_description(document, row_idx)
        values = row_values(document, row_idx)
        item_description_str = values.try(:gsub, /.*\d{8,}\s*/, '').try(:gsub, /\s*\d+.*/, '').try(:gsub, '|', '').try(:strip)
        item_description = strip_non_letters(item_description_str)
        { 'item_description' => item_description }
      end

      def parsed_customer_chain(document)
        customer_chain = parsed_data(document, 'customer_chain')
        { 'customer_chain' => customer_chain }
      end

      def strip_non_letters(string)
        string.try(:gsub, /^[\d\s\W\_]*/, '').try(:gsub, /[\d\s\W\_]*$/, '')
      end

      def parsed_customer_location(document, row_idx)
        values = row_values(document, row_idx)
        cols = values.try(:strip).try(:scan, /[a-z\s\&\']{5,}/i)
        customer_location_str = cols.try(:[], -2)
        customer_location = strip_non_letters(customer_location_str)

        # first_date_str = get_nth_date_str(values, 0)
        # customer_location = first_date_str.try(:length) < 3 ? get_nth_date_str(values, 1) : first_date_str

        { 'customer_location' => customer_location }
      end

      def text_chars(arr)
        arr.select{|v| v.match?(/[a-z]{4,}/i) && v.length > 4}
      end

      def get_nth_date_str(values, n)
        # date_regex = /\d{1,4}\/\d{1,4}\/\d{1,4}/
        # # date_regex = /\d{1,4}\/\d{1,4}\/\d{1,4}\w{4,}.*\d{1,4}\/\d{1,4}\/\d{1,4}.*$/i
        # cols = values.try(:split, date_regex)
        # text_cols = text_chars(cols)
        # col = text_cols.try(:[], 1).try(:split, '|')
        # text_chars(col).try(:first).try(:strip)
        # arr_index = values.each_index.select{ |i| values.try(:[], i).try(:match?, date_regex) }.try(:[], n)
        # date_str = values[arr_index] if !!arr_index
        # date_str_text = date_str.try(:gsub, /\d{1,4}\/\d{1,4}\/\d{1,4}.*/, '').try(:gsub, /(\||\$)/i, '').try(:strip) if date_str
        # date_str_text.blank? && arr_index > 0 ? values.try(:[], arr_index - 1) : date_str_text
      end

      def parsed_contract_type(document)
        contract_type = parsed_data(document, 'contract_type').try(:gsub, /[^\w\s]/, '').try(:strip)
        { 'contract_type' => contract_type }
      end

      def parsed_shipped(document, row_idx)
        shipped = parsed_digits(document, row_idx).try(:[], -3)
        { 'shipped' => shipped }
      end
    end
  end
end
