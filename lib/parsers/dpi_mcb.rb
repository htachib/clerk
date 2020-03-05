module Parsers
  class DpiMcb < Base
    class << self
      def parse_rows(document)
        rows = []
        row_count = line_items(document).try(:count)

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
        row = row_values(document, row_idx)
        dates = row.try(:scan, /\d{2}\/\d{2}\/\d{4}/)
        start_date = dates.try(:[], -2)
        end_date = dates.try(:[], -1)

        {
          'start_date' => start_date,
          'end_date' => end_date
        }
      end

      def line_items(document)
        raw_line_items = document.try(:[], 'line_items').map{|line| line.try(:values).try(:first)}
        merged_line_items = []
        line_items_stripped = raw_line_items.map { |l| l.try(:gsub, /\W+$/, '').try(:strip) }
        row_idx_with_totals = line_items_stripped.each_with_index.map{|line, idx| idx if line.try(:match?, /\d+(\.|\,)\d+$/) }
        split_row = ''
        line_items_stripped.each_with_index do |row, idx|
          split_row += row
          if row_idx_with_totals.include?(idx)
            merged_line_items.push(split_row)
            split_row = ''
          end
        end
        merged_line_items
      end

      def row_values(document, row_idx)
        line_items(document).try(:[], row_idx)
      end

      def parsed_digits(document, row_idx)
        values = row_values(document, row_idx)
        values.try(:scan, /\d+\.?\d*/)
      end

      def parsed_totals(document, row_idx)
        chargeback_amount = parsed_digits(document, row_idx).try(:last)
        { 'chargeback_amount' => chargeback_amount.to_dollars }
      end

      def parsed_upc(document, row_idx)
        values = row_values(document, row_idx)
        upc = values.try(:scan, /\d{8,}/).try(:last)
        { 'upc' => upc }
      end

      def parsed_item_description(document, row_idx)
        values = row_values(document, row_idx)
        if values.match?(/.*\d{8,}\s*/)
          item_description_str = values.try(:gsub, /.*\d{8,}\s*/, '').try(:gsub, /\s*\d+.*/, '').try(:gsub, '|', '').try(:strip)
        else
          item_description_str = values.try(:gsub, /(\d|\s|\W)+$/, '').try(:gsub, /.*\d+\/\d+\/\d+/, '').try(:strip)
        end
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
        row = row_values(document, row_idx)
        customer_location_str = strip_customer_location_string(row)
        customer_location = strip_non_letters(customer_location_str)

        { 'customer_location' => customer_location }
      end

      def strip_customer_location_string(string)
        pre_substring = remove_post_customer_location_substring(string)
        post_substring = remove_pre_customer_location_substring(pre_substring)
      end

      def remove_pre_customer_location_substring(string)
        string.gsub(/.*\d{3,}/,'')
      end

      def remove_post_customer_location_substring(string)
        substring = string.try(:gsub, /\d{1,4}\/\d{1,4}\/\d{1,4}.{1,5}\d{8,}.*/, '')
        date_index_arr = substring.enum_for(:scan, /\d{1,4}\/\d{1,4}\/\d{1,4}/).map { Regexp.last_match.offset(0).first }
        return substring if date_index_arr.empty?
        last_date_index = date_index_arr.try(:last)
        substring.try(:gsub, substring[last_date_index..-1], '')
      end

      def text_chars(arr)
        arr.select{|v| v.match?(/[a-z]{4,}/i) && v.length > 4}
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
