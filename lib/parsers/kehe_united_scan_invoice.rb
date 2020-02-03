module Parsers
  class KeheUnitedScanInvoice < Base
    class << self
      DATE_REGEX = /\d{1,4}\/\d{1,4}\/\d{1,4}/

      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document)).deep_merge(
        parsed_deduction_description(document))
      end

      def parsed_invoice_number(document)
        invoice_number = get_invoice_number(document)
        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_date(document)
        invoice_date_str = parsed_data(document, 'invoice_date')
        invoice_dates = invoice_date_str.try(:scan, DATE_REGEX)
        invoice_dates_count = invoice_dates.try(:length)
        if invoice_dates_count > 1
          start_date, end_date = invoice_dates
        elsif invoice_dates_count == 1
          start_date = end_date = invoice_dates.try(:first)
        else
          start_date = end_date = nil
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
        regex = /invoice.*total/i
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
