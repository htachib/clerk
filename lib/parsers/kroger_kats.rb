module Parsers
  class KrogerKats < Base
    class << self
      def parse_rows(document)
        rows = []
        row_count = document.try(:[], 'upc').count

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
        parsed_invoice_date(document)).deep_merge(
        parsed_totals(document, row_idx)).deep_merge(
        parsed_deduction_description(document)).deep_merge(
        parsed_upc(document, row_idx)).deep_merge(
        parsed_item_description(document, row_idx)).deep_merge(
        parsed_customer_location(document, row_idx)).deep_merge(
        parsed_shipped(document, row_idx))
      end

      def parsed_invoice_number(document)
        invoice_number = get_invoice_number(document)
        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_date(document)
        week_ending_date_str = parsed_data(document, 'week_ending_date')
        week_ending_date = Date.strptime(week_ending_date_str, '%m/%d/%Y')
        end_date = date_to_string(week_ending_date)
        start_date = date_to_string(week_ending_date - 6)

        {
          'start_date' => start_date,
          'end_date' => end_date
        }
      end

      def parsed_totals(document, row_idx)
        totals = get_totals(document)
        chargeback_amount = totals.try(:[], row_idx)
        { 'chargeback_amount' => chargeback_amount.to_dollars }
      end

      def parsed_deduction_description(document)
        deduction_description = parsed_data(document, 'deduction_description')

        { 'deduction_description' => deduction_description }
      end

      def parsed_upc(document, row_idx)
        parsed = document.try(:[], 'upc').try(:[], row_idx)
        upc = parsed.try(:values).try(:first)
        { 'upc' => upc }
      end

      def parsed_item_description(document, row_idx)
        parsed = document.try(:[], 'item_description').try(:[], row_idx)
        item_description = parsed.try(:values).try(:first)
        { 'item_description' => item_description }
      end

      def parsed_customer_location(document, row_idx)
        parsed = document.try(:[], 'customer_location').try(:[], row_idx)
        customer_location = parsed.try(:values).try(:first)
        { 'customer_location' => customer_location }
      end

      def parsed_shipped(document, row_idx)
        parsed = document.try(:[], 'shipped').try(:[], row_idx)
        shipped = parsed.try(:values).try(:first)
        { 'shipped' => shipped }
      end
    end
  end
end
