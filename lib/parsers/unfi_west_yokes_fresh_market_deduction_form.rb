module Parsers
  class UnfiWestYokesFreshMarketDeductionForm < Base
    class << self
      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document))
      end

      def parsed_invoice_number(document)
        match_from_file_name = invoice_number_file_name_match(document, 5)
        {'invoice_number' => match_from_file_name}
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
        invoice_total_amount = invoice_total_str.to_dollars
        chargeback_amount = chargeback_str.to_dollars

        {'chargeback_amount' => chargeback_amount,
          'invoice_total' => invoice_total_amount}
      end
    end
  end
end
