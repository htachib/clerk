module Parsers
  class UnfiWestChargeback < Base
    class << self
      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document)).deep_merge(
        parsed_deduction(document))
      end

      def parsed_invoice_date(document)
        invoice_date = get_invoice_date(document)

        {
          'start_date' => invoice_date,
          'end_date' => invoice_date
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
        regex = /chargeback.*amount/i
        get_total_in_dollars(totals, regex)
      end

      def parsed_deduction(document)
        purchase_order = parsed_data(document, 'purchase_order')
        deduction_reason = parsed_data(document, 'deduction_reason')

        deduction_mapping(deduction_reason, purchase_order)
      end

      def deduction_mapping(deduction_reason, purchase_order)
        if deduction_reason.try(:match?, /qty\s*quantity/i)
          { 'deduction_type' => 'Shortage',
            'deduction_description' => "Over/Short Ship - PO #{purchase_order}" }
        elsif deduction_reason.try(:match?, /prc\s*pricing/i)
          { 'deduction_type' => 'Off Invoice Allowance',
            'deduction_description' => "Price Discrepancy - PO #{purchase_order}" }
        else
          { 'deduction_type' => deduction_reason,
            'deduction_description' => "#{deduction_reason} - PO #{purchase_order}" }
        end
      end
    end
  end
end
