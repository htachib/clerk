module Parsers
  class KeheSpoilage < Base
    class << self
      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document)).deep_merge(
        parsed_deduction_description(document)).deep_merge(
        parsed_customer_name(document))
      end

      def parsed_invoice_number(document)
        invoice_number = get_invoice_number(document)
        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_date(document)
        invoice_dates = document.try(:[], 'invoice_date').try(:first)

        {
          'start_date' => invoice_dates.try(:[], 'start_date'),
          'end_date' => invoice_dates.try(:[], 'end_date')
        }
      end

      def parsed_totals(document)
        chargeback_amount = get_totals(document).try(:first)

        { 'chargeback_amount' => chargeback_amount }
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

      def parsed_customer_name(document)
        customer_name = parsed_data(document, 'customer')
        { 'customer_name' => customer_name }
      end
    end
  end
end
