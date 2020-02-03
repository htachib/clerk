module Parsers
  class UnfiWestWholeFoodsAdFee < Base
    class << self
      def parse_rows(document)
        rows = []
        row_count = document.try(:[], 'totals').count

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
        deduction_description = document.try(:[], 'deduction_description').try(:[], row_idx).try(:values).try(:first)
        month_int = month_int_from_string(deduction_description)
        invoice_date_str = date_from_month(month_int)
        invoice_dates = date_string_to_promo_dates(invoice_date_str)
        {
          'start_date' => invoice_dates.try(:[], 'start_date'),
          'end_date' => invoice_dates.try(:[], 'end_date')
        }
      end

      def date_from_month(month_int)
        return nil if !month_int
        this_year = Date.today.year
        last_year = this_year - 1
        month_this_year = Date.new(this_year, month_int, -1)
        month_past_year = Date.new(last_year, month_int, -1)
        month_this_year > Date.today ? month_past_year.strftime('%m%y') : month_this_year.strftime('%m%y')
      end

      def parsed_totals(document, row_idx)
        chargeback_amount = document.try(:[], 'totals').try(:[], row_idx).try(:values).try(:first)
        { 'chargeback_amount' => str_to_dollars(chargeback_amount) }
      end

      def parsed_deduction_description(document, row_idx)
        deduction_description = document.try(:[], 'deduction_description').try(:[], row_idx).try(:values).try(:first)
        { 'deduction_description' => deduction_description }
      end
    end
  end
end
