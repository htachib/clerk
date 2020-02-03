module Parsers
  class UnfiWestWholeFoodsInStoreExecutionFee < Base
    class << self
      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document))
      end

      def parsed_invoice_date(document)
        invoice_number = get_invoice_number(document)
        date_string = invoice_number.try(:scan, /^WFM(.....)/).try(:flatten).try(:first)
        invoice_dates = date_string_to_promo_dates(date_string)

        {
          'start_date' => invoice_dates.try(:[], 'start_date'),
          'end_date' => invoice_dates.try(:[], 'end_date')
        }
      end

      def parsed_invoice_number(document)
        match_from_file_name = invoice_number_file_name_match(document, 5)
        {'invoice_number' => match_from_file_name}
      end

      def parsed_totals(document)
        totals = get_totals(document)
        chargeback_amount = parsed_chargeback(totals)

        { 'chargeback_amount' => chargeback_amount }
      end

      def parsed_chargeback(totals)
        regex = /total.*participation.*cost/i
        get_total_in_dollars(totals, regex)
      end
    end
  end
end
