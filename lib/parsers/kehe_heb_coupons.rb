module Parsers
  class KeheHebCoupons < Base
    class << self
      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document)).deep_merge(
        parsed_shipped(document))
      end

      def parsed_invoice_number(document)
        invoice_number = get_invoice_number(document)
        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_date(document)
        row = get_raw_data(document, 'invoice_date').try(:flatten) || []
        invoice_date = row.try(:last)

        {
          'start_date' => invoice_date,
          'end_date' => invoice_date
        }
      end

      def parsed_totals(document)
        totals = get_totals(document)
        chargeback_amount = parsed_chargeback(totals)
        ep_fee_amount = parsed_ep_fee(totals)

        {'chargeback_amount' => chargeback_amount,
          'ep_fee' => ep_fee_amount}
      end

      def parsed_chargeback(totals)
        regex = /total.*invoice/i
        get_total_in_dollars(totals, regex)
      end

      def parsed_ep_fee(totals)
        regex = /ep.*fee/i
        get_total_in_dollars(totals, regex)
      end

      def parsed_shipped(document)
        shipped_arr = document.try(:[], 'shipped')
        shipped = shipped_arr.map { |h| h.try(:[], 'units').try(:to_i) }.try(:sum)
        {'shipped' => shipped}
      end
    end
  end
end
