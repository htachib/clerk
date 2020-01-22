module Parsers
  class UnfiWestNcgDeductionForm < Base
    class << self
      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document))
      end

      def parsed_invoice_date(document)
        invoice_number = get_invoice_number(document)
        date_string = invoice_number.try(:scan, /^(\d{4})/).try(:flatten).try(:first)
        invoice_dates = date_string_to_promo_dates(date_string)

        {
          'start_date' => invoice_dates.try(:[], 'start_date'),
          'end_date' => invoice_dates.try(:[], 'end_date')
        }
      end

      def parsed_invoice_number(document)
        invoice_number = get_invoice_number(document)
        {'invoice_number' => invoice_number}
      end

      def parsed_totals(document)
        totals = get_totals(document)
        chargeback_amount = parsed_chargeback(totals)

        { 'chargeback_amount' => chargeback_amount }
      end

      def parsed_chargeback(totals)
        regex = /deduction.*/i
        get_total_in_dollars(totals, regex)
      end
    end
  end
end
