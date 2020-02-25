module Parsers
  class UnfiWestWholeFoodsCouponsScans < Base
    class << self
      def parse_rows(document)
        rows = []
        row_count = document.try(:[], 'deduction_description').count

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
        parsed_totals(document, row_idx)).deep_merge(
        parsed_deduction_description(document, row_idx))
      end

      def parsed_invoice_number(document)
        match_from_file_name = invoice_number_file_name_match(document, 6)
        {'invoice_number' => match_from_file_name}
      end

      def parsed_invoice_date(document, row_idx)
        start_date = document.try(:[], 'start_date').try(:[], row_idx).try(:values).try(:first)
        end_date = document.try(:[], 'end_date').try(:[], row_idx).try(:values).try(:first)
        {
          'start_date' => start_date,
          'end_date' => end_date
        }
      end

      def parsed_totals(document, row_idx)
        chargeback_amount = document.try(:[], 'totals').try(:[], row_idx).try(:values).try(:first)
        { 'chargeback_amount' => chargeback_amount.to_dollars }
      end

      def parsed_deduction_description(document, row_idx)
        deduction_description = document.try(:[], 'deduction_description').try(:[], row_idx).try(:values).try(:first)
        { 'deduction_description' => deduction_description }
      end
    end
  end
end
