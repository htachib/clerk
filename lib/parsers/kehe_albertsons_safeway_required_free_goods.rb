module Parsers
  class KeheAlbertsonsSafewayRequiredFreeGoods < Base
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

        if invoice_date.include?('/')
          { 'start_date' => invoice_date,
            'end_date' => invoice_date }
        else
          invoice_dates = date_string_to_promo_dates(invoice_date)
          { 'start_date' => invoice_dates.try(:[], 'start_date'),
            'end_date' => invoice_dates.try(:[], 'end_date') }
        end
      end

      def parsed_totals(document)
        totals = get_totals(document)
        chargeback_amount = parsed_chargeback(totals)
        ep_fee_amount = parsed_ep_fee(totals)

        {'chargeback_amount' => chargeback_amount,
          'ep_fee' => ep_fee_amount}
      end

      def parsed_chargeback(totals)
        regex = /invoice.*total/i
        get_total_in_dollars(totals, regex)
      end

      def parsed_ep_fee(totals)
        regex = /ep.*fee/i
        get_total_in_dollars(totals, regex)
      end

      def parsed_deduction_description(document)
        deduction_description = parsed_data(document, 'deduction_description')
        { 'deduction_description' => deduction_description }
      end
    end
  end
end
