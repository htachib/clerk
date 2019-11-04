module Parsers
  class KeheRetailerStorePlacement < Base
    class << self
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

      def alt_invoice_num(meta_data, invoice_row)
        idx = meta_data.index(invoice_row)
        meta_data[idx].split(' ').last
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

      def parsed_deduction_description(document)
        options = ['deduction_description_option_1', 'deduction_description_option_2']
        data = options.map { |option| get_raw_data(document, option) }.flatten
        filtered = data.select { |row| row.length > 5 }
        description = longer_description(filtered)
        titled = titleize_with_spaces(description)
        syntax = titled.try(:gsub, /\(.*\)$/, '')
        {'deduction_description' => syntax}
      end

      def longer_description(arr)
        arr.max_by(&:length)
      end

      def parsed_customer_chain(document)
        if (document['customer_chain_option_1'].count > 1)
          data = get_raw_data(document,'customer_chain_option_2').try(:flatten).try(:first)
        else
          data = get_raw_data(document,'customer_chain_option_1').try(:flatten).try(:first)
        end
        {'customer_chain' => data}
      end

      def parsed_promo_date_range(document)
        date = get_promo_date(document)
        {'promo_date' => date}
      end

      def get_promo_date(document)
        option_one = get_raw_data(document,'promo_date_option_1').try(:flatten).try(:first)
        option_two = get_raw_data(document,'promo_date_option_2').try(:flatten).try(:first)
        option_three = get_raw_data(document,'promo_date_option_3').try(:flatten).try(:first)
        return option_one if option_one.try(:match?, /\d{1,2}\/\d{1,2}\/\d{2,4}/)
        return option_two if option_two.try(:match?, /\d{1,2}\/\d{1,2}\/\d{2,4}/)
        return option_three if option_three.try(:match?, /\d{1,2}\/\d{1,2}\/\d{2,4}/)
      end
    end
  end
end
