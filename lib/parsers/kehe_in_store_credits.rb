module Parsers
  class KeheInStoreCredits < Base
    class << self
      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document)).deep_merge(
        parsed_deduction_description(document)).deep_merge(
        parsed_customer_chain(document)).deep_merge(
        parsed_shipped(document))
      end

      def parsed_invoice_number(document)
        invoice_number = get_invoice_number(document)
        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_date(document)
        invoice_date_str = get_invoice_date(document)
        invoice_dates = date_string_to_promo_dates(invoice_date_str)

        {
          'start_date' => invoice_dates.try(:[], 'start_date'),
          'end_date' => invoice_dates.try(:[], 'end_date')
        }
      end

      def parsed_totals(document)
        chargeback_amount = parsed_data(document, 'totals')
        {'chargeback_amount' => chargeback_amount}
      end

      def parsed_shipped(document)
        shipped = parsed_data(document, 'shipped')
        {'shipped' => shipped}
      end

      def parsed_deduction_description(document)
        customer_chain = parsed_data(document, 'customer_chain')
        deduction_description = parsed_data(document, 'deduction_description')
        sanitized_deduction_description = deduction_description.try(:gsub, customer_chain, '').try(:gsub, /non.?service/i, '').try(:strip)
        { 'deduction_description' => sanitized_deduction_description }
      end

      def parsed_customer_chain(document)
        customer_chain = parsed_data(document, 'customer_chain')
        { 'customer_chain' => customer_chain }
      end
    end
  end
end
