module Parsers
  class UnfiWestBashasIncDeductionForm < Base
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
        invoice_total_str = parsed_data(document, 'invoice_total')
        chargeback_str = parsed_data(document, 'chargeback')
        invoice_total_amount = invoice_total_str.to_dollars
        chargeback_amount = chargeback_str.to_dollars

        {'chargeback_amount' => chargeback_amount,
          'invoice_total' => invoice_total_amount}
      end

      def parsed_deduction_description(document)
        deduction_description = parsed_data(document, 'deduction_description')
        { 'deduction_description' => deduction_description }
      end
    end
  end
end
