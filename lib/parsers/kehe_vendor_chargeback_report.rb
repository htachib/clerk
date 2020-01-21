module Parsers
  class KeheVendorChargebackReport < Base
    class << self
      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document)).deep_merge(
        parsed_deduction_description(document)).deep_merge(
        parsed_customer(document))
      end

      def parsed_invoice_number(document)
        invoice_number = get_invoice_number(document)
        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_date(document)
        start_date = parsed_data(document, 'start_date')
        end_date = parsed_data(document, 'end_date')

        {
          'start_date' => start_date,
          'end_date' => end_date
        }
      end

      def parsed_totals(document)
        totals = get_totals(document)
        chargeback_amount = parsed_chargeback(totals)

        { 'chargeback_amount' => chargeback_amount }
      end

      def parsed_chargeback(totals)
        regex = /vendor.*total/i
        get_total_in_dollars(totals, regex)
      end

      def parsed_deduction_description(document)
        deduction_description = parsed_data(document, 'deduction_description')
        { 'deduction_description' => deduction_description }
      end

      def parsed_customer(document)
        customer = parsed_data(document, 'customer')
        { 'customer' => customer }
      end
    end
  end
end
