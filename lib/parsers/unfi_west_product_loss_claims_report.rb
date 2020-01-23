module Parsers
  class UnfiWestProductLossClaimsReport < Base
    class << self

      DATE_REGEX = /PLC(.....).*CASA/.freeze

      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document))
      end

      def parsed_invoice_date(document)
        invoice_number = get_invoice_number(document)

        date_string = invoice_number.try(:scan, DATE_REGEX).try(:flatten).try(:first)
        invoice_dates = date_string_to_promo_dates(date_string)

        {
          'start_date' => invoice_dates.try(:[], 'start_date'),
          'end_date' => invoice_dates.try(:[], 'end_date')
        }
      end

      def parsed_invoice_number(document)
        invoice_number = get_invoice_number(document)
        {'invoice_number' => invoice_number}
      end

      def parsed_totals(document)
        chargeback_str = parsed_data(document, 'totals')
        chargeback_amount = str_to_dollars(chargeback_str)

        { 'chargeback_amount' => chargeback_amount }
      end
    end
  end
end
