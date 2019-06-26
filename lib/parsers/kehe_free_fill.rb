module Parsers
  class KeheFreeFill < Base
    class << self
      include Parsers::Helpers::KeheSanitizers

      def parsed_invoice_number(meta_data)
        row_regex = /invoice.*#/i
        str_regex = /invoice.*#/i
        sanitize_invoice_num(meta_data, row_regex, str_regex)
      end

      def alt_invoice_number(meta_data, invoice_row)
        idx = meta_data.index(invoice_row)
        idx ? meta_data[idx].split(/(\s|\:)/).last : nil
      end

      def parsed_type(meta_data)
        regex = /type.*:?/i
        type_row = string_match_from_arr(meta_data, regex)
        type_row.to_s.gsub(/type:?/i,'').strip
      end

      def parsed_customer(meta_data)
        regex = /free.*fill/i
        customer_row = string_match_from_arr(meta_data, regex)
        customer_row ? customer_row.to_s.gsub(/[^a-zA-Z]free.*fill/i,'').strip : nil
      end

      def parsed_meta_data(document)
        meta_data = get_meta_data(document)
        invoice_number = invoice_num_from_file_name(document) || parsed_invoice_number(meta_data)
        type = parsed_type(meta_data)
        customer = parsed_customer(meta_data)

        {'invoice number' => invoice_number,
          'Type' => type,
          'customer_name' => customer}
      end

      def parsed_invoice_date(document)
        invoice_date_row = get_raw_data(document, 'invoice_date')
        date = get_invoice_date(invoice_date_row, document)
        {'invoice_date' => date}
      end

      def parsed_totals(document)
        invoice_total_regex = /total.*for.*kettle/i
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
