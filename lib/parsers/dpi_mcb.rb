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

      def get_line_item(document, row_idx)
        document.try(:[], 'line_items').try(:[], row_idx)
      end

      def parsed_digits(document, row_idx)
        values = row_values(document, row_idx)
        matches = []
        values.each do |v|
          matches.push(v) if !v.match?(/[a-z]/i) && !v.match?(/\/+/) && v.match?(/\d+/)
        end

        matches
      end

      def row_values(document, row_idx)
        line_item = get_line_item(document, row_idx)
        line_item.try(:values)
      end

      def parsed_totals(document, row_idx)
        chargeback_amount = parsed_digits(document, row_idx).try(:last)
        { 'chargeback_amount' => str_to_dollars(chargeback_amount) }
      end

      def parsed_upc(document, row_idx)
        values = row_values(document, row_idx)
        upc = values.try(:join, ' ').try(:scan, /\d{8,}/).try(:last)
        { 'upc' => upc }
      end

      def parsed_item_description(document, row_idx)
        values = row_values(document, row_idx)
        item_description = values.try(:join, ' ').try(:gsub, /.*\d{8,}\s*/, '').try(:gsub, /\s*\d+.*/, '').try(:gsub, '|', '').try(:strip)
        { 'item_description' => item_description }
      end

      def parsed_customer_chain(document)
        customer_chain = parsed_data(document, 'customer_chain')
        { 'customer_chain' => customer_chain }
      end

      def parsed_customer_location(document, row_idx)
        values = row_values(document, row_idx)
        date_regex = /\d{1,4}\/\d{1,4}\/\d{1,4}/

        arr_index = values.each_index.select{ |i| values.try(:[], i).try(:match?, date_regex) }.try(:first)
        date_str = values[arr_index] if !!arr_index
        date_str_text = date_str.try(:gsub, /\d{1,4}\/\d{1,4}\/\d{1,4}.*/, '').try(:gsub, /[^[a-z]\s]/i, '').try(:strip) if date_str
        customer_location = date_str_text.blank? ? values.try(:[], arr_index - 1) : date_str_text

        { 'customer_location' => customer_location }
      end

      def parsed_contract_type(document)
        contract_type = parsed_data(document, 'contract_type')
        { 'contract_type' => contract_type }
      end

      def parsed_shipped(document, row_idx)
        shipped = parsed_digits(document, row_idx).try(:join, ' ').try(:gsub, /[^\d\.\s]/,'').try(:split, ' ').try(:[], -3)
        { 'shipped' => shipped }
      end
    end
  end
end
