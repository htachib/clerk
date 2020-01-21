module Parsers
  class KeheInvoiceAdjustment < Base
    class << self
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
        invoice_date = get_invoice_date(document)

        {
          'start_date' => invoice_date,
          'end_date' => invoice_date
        }
      end

      def parsed_totals(document)
        totals = get_totals(document)
        chargeback_amount = parsed_chargeback(totals)

        { 'chargeback_amount' => chargeback_amount }
      end

      def parsed_chargeback(totals)
        regex = /net.*deduction/i
        get_total_in_dollars(totals, regex)
      end

      def parsed_deduction_description(document)
        deduction_string = parsed_data(document, 'deduction_description')
        deduction_type = deduction_string.try(:match?, /product\s*variance/i) ? 'Shortage' : 'Off Invoice Allowance'
        deduction_description = deduction_string.try(:match?, /product\s*variance/i) ? 'Shortage' : 'Marketing Allowance Adjustment'
        { 'deduction_description' => deduction_description,
          'deduction_type' => deduction_type }
      end
    end
  end
end
