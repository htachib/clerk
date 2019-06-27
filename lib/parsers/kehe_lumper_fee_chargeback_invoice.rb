module Parsers
  class KeheLumperFeeChargebackInvoice < Base
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
        type_row.to_s.gsub(/type\W?/i,'').strip
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

      def calc_grand_total(one, two)
        one && two ? one + two : nil
      end

      def parsed_totals(document)
        totals = get_totals(document)
        total_amount = parsed_chargeback(totals)
        subtotal_amount = parsed_subtotal(totals)
        ep_fee_amount = parsed_ep_fee(totals)
        chargeback_amount = total_amount ||
                            calc_grand_total(subtotal_amount, ep_fee_amount)

        {'chargeback_amount' => chargeback_amount,
          'ep_fee' => ep_fee_amount}
      end

      def parsed_chargeback(totals)
        invoice_total_regex = /invoice.*total/i
        get_total_in_dollars(totals, invoice_total_regex)
      end

      def parsed_subtotal(totals)
        subtotal_regex = /(promo|chargeback)/i
        get_total_in_dollars(totals, subtotal_regex)
      end

      def parsed_ep_fee(totals)
        ep_fee_regex = /ep.*fee/i
        ep_fee_amount = get_total_in_dollars(totals, ep_fee_regex)
      end
    end
  end
end
