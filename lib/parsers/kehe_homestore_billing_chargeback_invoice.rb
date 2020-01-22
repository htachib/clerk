module Parsers
  class KeheHomestoreBillingChargebackInvoice < Base
    class << self
      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document)).deep_merge(
        parsed_customer_chain(document))
      end

      def parsed_invoice_number(document)
        invoice_number = get_invoice_number(document)
        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_date(document)
        date_string = get_invoice_date(document)
        invoice_dates = date_string_to_promo_dates(date_string)

        {
          'start_date' => invoice_dates.try(:[], 'start_date'),
          'end_date' => invoice_dates.try(:[], 'end_date')
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

      def parsed_customer_chain(document)
        customer_chain = parsed_data(document, 'customer_chain')
        { 'customer_chain' => customer_chain }
      end
    end
  end
end
