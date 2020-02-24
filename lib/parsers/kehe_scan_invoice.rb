module Parsers
  class KeheScanInvoice < Base
    class << self
      def invoice_data(document)
        parsed_meta_data(document).deep_merge(
        parsed_invoice_date(document)).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_customer(document)).deep_merge(
        parsed_deduction_description(document)).deep_merge(
        parsed_promo_date_range(document)).deep_merge(
        parsed_customer_chain(document))
      end

      def parsed_invoice_number(meta_data)
        row_regex = /invoice.*#/i
        str_regex = /invoice.*#/i
        sanitize_invoice_num(meta_data, row_regex, str_regex)
      end

      def customer_row_idx(rows)
        row_idx = rows.find_index{|row| row.to_s.match?(/(phone|fax)/i)}
        row_idx ? row_idx + 1 : nil
      end

      def sanitized_customer(rows)
        customer_row = rows.try(:last)
        if customer_row.to_s.match?(/(chargeback.*invoice)/i)
          idx = customer_row_idx(rows)
          row = rows.try(:[], idx)
          customer_row = row.to_s.match?(/chargeback.*invoice/i) ? 'KeHE' : row
        end

        regex = /(date|\#|scans|scan|chargeback|invoice|reclamation|recovery|date.*invoice$)/i
        customer_row.to_s.try(:gsub,regex,'').strip
      end

      def parsed_customer(document)
        rows = get_customer_data(document)
        customer = sanitized_customer(rows)
        {'detailed_customer' => customer}
      end

      def parsed_type(meta_data)
        regex = /type.*:?/i
        type_row = string_match_from_arr(meta_data, regex)
        type_row.to_s.try(:gsub,/type\W?/i,'').strip
      end

      def parsed_meta_data(document)
        meta_data = get_meta_data(document)
        invoice_number = invoice_num_from_file_name(document) || parsed_invoice_number(meta_data)
        type = parsed_type(meta_data)

        {'invoice_number' => invoice_number,
          'type' => type}
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

      def parsed_deduction_description(document)
        data = get_deduction_description(document)
        {'deduction_description' => data}
      end

      def get_deduction_description(document)
        option_one = get_raw_data(document,'deduction_description_option_1').try(:flatten).try(:first)
        option_two = get_raw_data(document,'deduction_description_option_2').try(:flatten).try(:first)
        option_three = get_raw_data(document,'deduction_description_option_3').try(:flatten).try(:first)
        return option_one if option_one && deduction_description_mismatch?(option_one)
        return option_two if option_two && deduction_description_mismatch?(option_two)
        return option_three if option_three && deduction_description_mismatch?(option_three)
      end

      def deduction_description_mismatch?(string)
        !string.try(:match?, /(fire|vendor)/i)
      end

      def parsed_promo_date_range(document)
        data = get_raw_data(document,'promo_row').try(:flatten).try(:first)
        range = data.try(:scan, /(\d{1,4}\/\d{1,4}\/\d{1,4})/).try(:flatten)
        {'start_date' => range.try(:first),
         'end_date' => range.try(:last)}
      end

      def parsed_customer_chain(document)
        data = get_raw_data(document,'customer_chain').try(:flatten).try(:first)
        {'customer_chain' => data}
      end
    end
  end
end
