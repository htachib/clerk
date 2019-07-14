module Parsers
  class KeheChargebackInvoiceHomestoreBilling < Base
    class << self
      include Parsers::Helpers::KeheSanitizers

      def invoice_data(document)
        parsed_meta_data(document).deep_merge(
        parsed_invoice_date(document)).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_deduction_description(document)).deep_merge(
        parsed_customer_chain(document)).deep_merge(
        parsed_promo_date_range(document))
      end

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
        totals = get_totals(document)
        chargeback_amount = parsed_chargeback(totals)
        ep_fee_amount = parsed_ep_fee(totals)

        {'chargeback_amount' => chargeback_amount,
          'ep_fee' => ep_fee_amount}
      end

      def parsed_chargeback(totals)
        invoice_total_row = totals ? totals.select{ |row| row.match(/$/)}.last : nil
        invoice_total = get_amount_str(invoice_total_row)
        str_to_dollars(invoice_total)
      end

      def parsed_ep_fee(totals)
        ep_fee_regex = /ep.*fee/i
        get_total_in_dollars(totals, ep_fee_regex)
      end

      def parsed_promo_date_range(document)
        data = get_raw_data(document,'promo_dates').flatten.try(:first)
        month_int, year_int = data.try(:scan,/[\d\s]+/).try(:first).try(:split, /\s/)
        start_date = date_formatted_promo(year_int, month_int, 1)
        end_date = date_formatted_promo(year_int, month_int, -1)
        {'start_date' => start_date,
         'end_date' => end_date}
      end

      def parsed_deduction_description(document)
        data = get_raw_data(document,'deduction_description').flatten.try(:first)
        {'deduction_description' => titleize_with_spaces(data)}
      end

      def parsed_customer_chain(document)
        data = get_raw_data(document,'customer_chain').flatten.try(:first).try(:strip)
        {'customer_chain' => data }
      end
    end
  end
end
