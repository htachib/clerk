module Parsers
  class UnfiEastQualityDeduction < Base
    class << self
      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document))
      end

      def parsed_invoice_date(document)
        file_name = document.try(:[], 'file_name')
        date_string = file_name.try(:scan, /^CMQ(.....)/).try(:flatten).try(:first)
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
        chargeback_amount = get_totals(document).try(:first)

        { 'chargeback_amount' => chargeback_amount }
      end
    end
  end
end
