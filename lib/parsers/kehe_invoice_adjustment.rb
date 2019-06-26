module Parsers
  class KeheInvoiceAdjustment < Base
    class << self
      include Parsers::Helpers::KeheSanitizers

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

      def parsed_invoice_date(document)
        invoice_date_row = get_raw_data(document, 'invoice_date')
        date = get_invoice_date(invoice_date_row, document)
        {'invoice_date' => date}
      end

      def parsed_totals(document)
        invoice_total_regex = /invoice.*total/i
        totals = get_totals(document)
        chargeback_amount = get_total_in_dollars(totals, invoice_total_regex)

        {'chargeback_amount' => chargeback_amount}
      end
    end
  end
end
