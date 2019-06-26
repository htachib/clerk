module Parsers
  class KeheNewItemSetup < Base
    class << self
      include Parsers::Helpers::KeheSanitizers

      def parsed_invoice_number(meta_data)
        row_regex = /invoice.*#/i
        str_regex = /invoice.*#/i
        sanitize_invoice_num(meta_data, row_regex, str_regex)
      end

      def parsed_type(meta_data)
        regex = /type.*:?/i
        type_row = string_match_from_arr(meta_data, regex)
        type_row.to_s.gsub(/type:?/i,'').strip
      end

      def parsed_meta_data(document)
        meta_data = get_meta_data(document)
        invoice_number = invoice_num_from_file_name(document) || parsed_invoice_number(meta_data)
        type = parsed_type(meta_data)

        {'invoice number' => invoice_number,
          'Type' => type}
      end

      def parsed_invoice_date(document)
        invoice_date_row = get_raw_data(document, 'invoice_date')
        date = get_invoice_date(invoice_date_row, document)
        {'invoice_date' => date}
      end

      def parsed_totals(document)
        totals = get_raw_data(document, 'totals').flatten
        invoice_total_row = totals.select{ |row| row.match(/$/)}.last
        invoice_total = get_amount_str(invoice_total_row)
        chargeback_amount = str_to_dollars(invoice_total)

        {'chargeback_amount' => chargeback_amount}
      end
    end
  end
end
