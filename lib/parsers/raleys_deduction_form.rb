module Parsers
  class RaleysDeductionForm < Base
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
        start_date = parsed_data(document, 'start_date')
        end_date = parsed_data(document, 'end_date')

        {
          'start_date' => start_date,
          'end_date' => end_date
        }
      end

      def parsed_totals(document)
        invoice_total_str = parsed_data(document, 'invoice_total')
        chargeback_str = parsed_data(document, 'chargeback')
        invoice_total_amount = str_to_dollars(invoice_total_str)
        chargeback_amount = str_to_dollars(chargeback_str)

        {'chargeback_amount' => chargeback_amount,
          'invoice_total' => invoice_total_amount}
      end

      def parsed_deduction_description(document)
        deduction_description = parsed_data(document, 'deduction_description')
        deduction_type = parsed_data(document, 'deduction_type')

        {'deduction_description' => deduction_description,
          'deduction_type' => deduction_type
        }
      end
    end
  end
end
