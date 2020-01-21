module Parsers
  class KeheSlottingPlacement < Base
    class << self
      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document)).deep_merge(
        parsed_deduction_description(document)).deep_merge(
        parsed_customer_chain(document))
      end

      def parsed_invoice_number(document)
        invoice_number = get_invoice_number(document)
        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_date(document)
        invoice_date = get_invoice_date(document)

        {
          'start_date' => invoice_date,
          'end_date' => invoice_date
        }
      end

      def parsed_totals(document)
        chargeback_amount = parsed_chargeback(document)
        ep_fee_amount = parsed_ep_fee(document)

        {'chargeback_amount' => chargeback_amount,
          'ep_fee' => ep_fee_amount}
      end

      def parsed_chargeback(document)
        totals = get_totals(document)
        regex = /ep.*fee/i

        ep_fee_id = nil
        totals.each_with_index { |total, idx| ep_fee_id = idx if total.try(:match?, regex) }

        totals.delete_at(ep_fee_id)
        totals.try(:first)
      end

      def parsed_ep_fee(document)
        totals = get_totals(document)
        regex = /ep.*fee/i
        get_total_in_dollars(totals, regex)
      end

      def parsed_deduction_description(document)
        deduction_description = parsed_data(document, 'deduction_description')
        { 'deduction_description' => deduction_description }
      end

      def parsed_customer_chain(document)
        customer_chain = parsed_data(document, 'customer_chain')
        { 'customer_chain' => customer_chain }
      end
    end
  end
end
