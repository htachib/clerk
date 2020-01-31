module Parsers
  class UnfiEastOverpullSupplierBillingReport < Base
    class << self
      DATE_REGEX = /^010VP(....)/.freeze

      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document))
      end

      def parsed_invoice_number(document)
        invoice_number_str = get_invoice_number(document)
        prepend = invoice_number_str.try(:[], 0..4)

        invoice_number = ('010VP' == prepend.try(:gsub, 'O', '0')) ? "01OVP#{invoice_number_str.try(:[], 5..-1)}" : invoice_number_str
        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_date(document)
        invoice_number = get_invoice_number(document)
        dummy_invoice_number = invoice_number.try(:gsub, 'O', '0')

        date_string = dummy_invoice_number.try(:scan, DATE_REGEX).try(:flatten).try(:first)
        invoice_dates = date_string_to_promo_dates(date_string)

        {
          'start_date' => invoice_dates.try(:[], 'start_date'),
          'end_date' => invoice_dates.try(:[], 'end_date')
        }
      end

      def parsed_totals(document)
        totals = get_totals(document)
        chargeback_amount = str_to_dollars(totals)

        { 'chargeback_amount' => chargeback_amount }
      end
    end
  end
end
