module Parsers
  class UnfiWestAkinsNaturalFoodsSupermarketDeductionForm < Base
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
        month = month_int_from_string(invoice_date).try(:to_s)
        year = invoice_date.try(:scan, /\d+$/i).try(:last)
        month = month.try(:length).try(:<, 2) ? "0#{month}" : month
        date_string = month + year if month && year
        invoice_dates = date_string_to_promo_dates(date_string)

        {
          'start_date' => invoice_dates.try(:[], 'start_date'),
          'end_date' => invoice_dates.try(:[], 'end_date')
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
