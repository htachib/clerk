module Parsers
  class GelsonsMarketsDeductionForm < Base
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
        invoice_date = get_invoice_date(document)

        {
          'start_date' => invoice_date,
          'end_date' => invoice_date
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
    end
  end
end
