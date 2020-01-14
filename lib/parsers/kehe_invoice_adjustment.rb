module Parsers
  class KeheInvoiceAdjustment < Base
    class << self
      def parsed_invoice_number(meta_data)
        row_regex = /invoice.*number/i
        str_regex = /invoice.*number.*:/i
        sanitize_invoice_num(meta_data, row_regex, str_regex)
      end

      def sanitize_invoice_num(meta_data, row_regex, str_regex)
        invoice_rows = invoice_rows(meta_data, row_regex)
        get_invoice_number(invoice_rows, str_regex)
      end

      def parsed_meta_data(document)
        meta_data = get_meta_data(document)
        invoice_number = invoice_num_from_file_name(document) || parsed_invoice_number(meta_data)
        {'invoice number' => invoice_number}
      end

      def parsed_totals(document)
        totals = get_totals(document)
        chargeback_amount = totals.try(:first)

        {'chargeback_amount' => chargeback_amount}
      end
    end
  end
end
