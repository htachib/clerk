module Parsers
  class KeheAdInvoice < Base
    class << self
      include Parsers::Helpers::KeheSanitizers
      
      def parsed_invoice_number(meta_data)
        row_regex = /invoice.*#/i
        str_regex = /invoice.*#/i
        sanitize_invoice_num(meta_data, row_regex, str_regex)
      end

      def parsed_meta_data(document)
        meta_data = get_meta_data(document)

        invoice_number = invoice_num_from_file_name(document) || parsed_invoice_number(meta_data)

        type_regex = /type.*:?/i
        type_row = string_match_from_arr(meta_data, type_regex)
        type = type_row.to_s.gsub(/type:?/i,'').strip

        {'invoice number' => invoice_number,
          'Type' => type}
      end

      def parsed_invoice_date(document)
        invoice_date_row = get_raw_data(document, 'invoice_date')
        date = get_invoice_date(invoice_date_row, document)
        {'invoice_date' => date}
      end

      def parsed_totals(document)
        invoice_total_regex = /invoice.*total/i
        ep_fee_regex = /ep.*fee/i

        totals = get_totals(document)
        chargeback_amount = get_total_in_dollars(totals, invoice_total_regex)
        ep_fee_amount = get_total_in_dollars(totals, ep_fee_regex)

        {'chargeback_amount' => chargeback_amount,
          'ep_fee' => ep_fee_amount}
      end
    end
  end
end
