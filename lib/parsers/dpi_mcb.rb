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
        start_date = invoice_dates.try(:[], 'start_date')
        end_date = invoice_dates.try(:[], 'end_date')

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
        joined_values = values[4..-1].try(:join, ' ')
        upc = joined_values.try(:scan, /\d{6,}/).try(:first)
        { 'upc' => upc }
      end

      def parsed_item_description(document, row_idx)
        values = row_values(document, row_idx)
        last_date_index = values.each_index.select{ |i| values.try(:[], i).try(:match?, /\/+/) }.try(:last)
        return { 'item_description' => nil } if !last_date_index

        item_description_index = last_date_index + 1
        item_description_index += 1 if !values.try(:[], item_description_index).try(:match?, /[a-z]{3,}/i)
        item_description = values.try(:[], item_description_index).try(:gsub, /^\d+\s*/, '')
        { 'item_description' => item_description }
      end

      def parsed_customer_chain(document)
        customer_chain = parsed_data(document, 'customer_chain')
        { 'customer_chain' => customer_chain }
      end

      def parsed_customer_location(document, row_idx)
        values = row_values(document, row_idx)
        arr_index = values.each_index.select{ |i| values.try(:[], i).try(:match?, /\/+/) }.try(:first)
        customer_location_idx = arr_index - 1 if !!arr_index
        customer_location = values.try(:[], customer_location_idx) if !!customer_location_idx
        { 'customer_location' => customer_location }
      end

      def parsed_contract_type(document)
        contract_type = parsed_data(document, 'contract_type')
        { 'contract_type' => contract_type }
      end

      def parsed_shipped(document, row_idx)
        shipped = parsed_digits(document, row_idx).try(:[], -3)
        { 'shipped' => shipped }
      end
    end
  end
end
