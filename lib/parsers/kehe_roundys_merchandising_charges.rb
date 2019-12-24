module Parsers
  class KeheRoundysMerchandisingCharges < Base
    class << self
      def invoice_data(document)
        parsed_meta_data(document).deep_merge(
        parsed_invoice_date(document)).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_customer(document)).deep_merge(
        parsed_promo_date_range(document)).deep_merge(
        parsed_deduction_description(document))
      end

      def parsed_invoice_number(meta_data)
        row_regex = /invoice.*#/i
        str_regex = /invoice.*#/i
        sanitize_invoice_num(meta_data, row_regex, str_regex)
      end

      def customer_string(rows)
        regex = /(chargeback.*\/.*invoice)/i
        regex_two = /^\s*charges\s*/i
        regex_three = /\d+/
        regex_four = /^\s*date/i

        rows.select do |row|
          !row.match(regex) && !row.match(regex_two) &&
          !row.match(regex_three) && !row.match(regex_four)
        end.first
      end

      def sanitized_customer(rows)
        customer_str = customer_string(rows)
        customer_str.try(:gsub,/(invoice\s*#?|charge|date|program|merchandising)/i,'').strip
      end

      def parsed_customer(document)
        rows = get_raw_data(document, 'customer').flatten
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
        options = ['promo_dates_option_1', 'promo_dates_option_2']
        promo_dates_data = options.map { |option| get_raw_data(document, option) }.flatten.try(:first) # [], ["201811"], ["201810"], ["1/1/19-3/2/19"]
        {'promo_dates' => get_promo_dates(document, promo_dates_data)}
      end

      def get_promo_dates(document, string)
        start_date = parsed_invoice_date(document).try(:[], 'invoice_date')
        end_date = parsed_invoice_date(document).try(:[], 'invoice_date')
        if date_string(string).try(:count) == 2
          dates = date_string(string).try(:flatten)
          start_date = dates.first
          end_date = dates.last
        elsif string.try(:match?, /\d+{6}/)
          digits = string.try(:match, /\d+/).try(:[], 0)
          month_int = digits[-2..-1]
          year_int = digits[0..3]
          start_date = date_formatted_promo(year_int, month_int, 1)
          end_date = date_formatted_promo(year_int, month_int, -1)
        end
        {'start_date' => start_date,
         'end_date' => end_date}
      end

      def date_string(string)
        string.try(:scan, /(\d{1,4}\/\d{1,4}\/\d{1,4})/)
      end

      def parsed_deduction_description(document)
        options = ['deduction_description_option_1', 'deduction_description_option_2',
                   'deduction_description_option_3']
        data = options.map { |option| get_raw_data(document, option) }.flatten
        filtered = data.select {|d| d.length < 100 && d.length > 3 }
        description = longer_description(filtered)
        shortened_descr = remove_chargeback_invoice_language(description)
        {'deduction_description' => titleize_with_spaces(shortened_descr)}
      end

      def longer_description(arr)
        arr.max_by(&:length)
      end

      def remove_chargeback_invoice_language(string)
        string.try(:gsub, /^chargeback.*invoice/i, '').try(:strip)
      end
    end
  end
end
