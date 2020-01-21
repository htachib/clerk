module Parsers
  class KeheSproutsAdvertisement < Base
    class << self
      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document))
      end

      def parsed_invoice_number(document)
        invoice_number = get_invoice_number(document)
        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_date(document)
        invoice_dates = document.try(:[], 'invoice_date').try(:first)
        start_date = invoice_dates['start_date']
        end_date = invoice_dates['end_date']

        start_date_year_digits = start_date.try(:scan, /\d+$/).try(:first)
        end_date_year_digits = end_date.try(:scan, /\d+$/).try(:first)
        if !!start_date_year_digits && !!end_date_year_digits && end_date_year_digits.try(:length) < start_date_year_digits.try(:length)
          end_date = replace_year(end_date, start_date_year_digits)
        end

        {
          'start_date' => start_date,
          'end_date' => end_date
        }
      end

      def parsed_totals(document)
        totals = get_totals(document)
        chargeback_amount = parsed_chargeback(totals)
        ep_fee_amount = parsed_ep_fee(totals)

        {'chargeback_amount' => chargeback_amount,
          'ep_fee' => ep_fee_amount}
      end

      def parsed_chargeback(totals)
        regex = /total.*for/i
        get_total_in_dollars(totals, regex)
      end

      def parsed_ep_fee(totals)
        regex = /ep.*fee/i
        get_total_in_dollars(totals, regex)
      end

      def parsed_deduction_description(document)
        deduction_description = parsed_data(document, 'deduction_description')
        { 'deduction_description' => deduction_description }
      end
    end
  end
end
