module Parsers
  module Helpers
    module GlobalSanitizers
      MONTHS_LIST =  %w(jan feb mar apr may jun jul aug sep oct nov dec)

      def str_to_dollars(str_amount)
        return nil if !str_amount
        amount = str_amount.to_s.try(:gsub,/(\,|\$)/,'')
        cents_str = amount.try(:split, /(\.|\s)/).try(:last) || 0
        dollar_str = amount.try(:split, /(\.|\s)/).try(:first) || 0
        return '' if !cents_str && !dollar_str
        (dollar_str.to_f) + (cents_str.to_f / 100)
      end

      def get_amount_str(totals_arr)
        totals_arr ? totals_arr.match(/\$(\d|\,|\.){1,}/).try(:[], 0).try(:gsub,'$','') : nil
      end

      def invoice_num_from_file_name(document)
        document['file_name'].split(' ').first.match(/([a-zA-Z]|\d){5,}/).try(:[], 0)
      end

      def invoice_number_file_name_match?(document, char_match_count)
        file_name_invoice_number = invoice_num_from_file_name(document)
        parsed_invoice_number = get_invoice_number(document)
        substring_match?(file_name_invoice_number, parsed_invoice_number, char_match_count)
      end

      def substring_match?(option_a, option_b, char_count)
        n = option_b.length - char_count
        is_match = false

        n.times do |i|
          substring = option_b[i..(i + char_count)]
          is_match = true if option_a.include?(substring)
        end
        is_match
      end

      def invoice_date_from_file_name(document)
        date_str = document["file_name"].match(/\d{2,4}-\d{1,2}-\d{1,2}/).try(:[], 0)
        sanitize_date_year_month_day(date_str)
      end

      def sanitize_date_year_month_day(string)
        substring = string.split('-')
        "#{substring[1]}/#{substring[2]}/#{substring[0]}"
      end

      def string_match(string, regex)
        regex_match = string.to_s.match(regex)
        regex_match ? regex_match[0].to_s : nil
      end

      def string_match_from_arr(arr, regex)
        return arr if arr.try(:class) == String
        arr.select{ |row| row.match?(regex) }.try(:first) || nil
      end

      def get_raw_data(document, type)
        return [] if !document[type]
        document[type].map {|row| row.values } || []
      end

      def month_int_from_string(string)
        idx = MONTHS_LIST.each_index.select{ |i| string.try(:downcase).include? MONTHS_LIST[i] }.try(:first)
        idx ? idx + 1 : nil
      end

      def month_count_from_string(string)
        MONTHS_LIST.each_index.select{ |i| string.try(:downcase).include? MONTHS_LIST[i] }.try(:count)
      end

      def soft_fail(string)
        defined?(string) ? string : ''
      end

      def string_to_date(string)
        string.try(:scan, /\d{1,2}\/\d{1,2}\/\d{2,4}/)
      end

      def date_formatted_promo(year, month, day = 1)
        return nil unless (year && month)
        DateTime.new(year.to_i, [month.to_i, 12].min, [day.to_i, 31].min).strftime("%m/%d/%y")
      end

      def format_month_year(string)
        return nil unless [4, 5, 6, 7].include?(string.to_s.length)

        case string.try(:to_s).try(:length)
        when 4 #yyyy or mmyy
          month, year = four_digit_date(string)
        when 5 #mmmyy or #yymmm
          month, year = five_digit_date(string)
        when 6 #mmyyyy
          month, year = six_digit_date(string)
        when 7 #mmmyyyy
          month, year = seven_digit_date(string)
        end

        return month, year
      end

      def four_digit_date(string)
        if string.try(:first).try(:to_i) > 1 #yyyy
          month = 12 # end of year report if no month is stated
          year = string.try(:to_i)
        else #mmyy
          month = string.try(:to_s).try(:[], 0..1)
          year_int = string.try(:[], -2..-1).try(:to_i)
          year = year_int + (year_int < 70 ? 2000 : 1900)
        end

        return month, year
      end

      def five_digit_date(string)
        if string.try(:first).try(:to_i) > 1 #yymmm
          month_string = string.try(:to_s).try(:[], -3..-1)
          month = month_int_from_string(month_string)
          year_int = string.try(:[], 0..1).try(:to_i)
          year = year_int + (year_int < 70 ? 2000 : 1900)
        else #mmmyy
          month_string = string.try(:to_s).try(:[], 0..2)
          month = month_int_from_string(month_string)
          year_int = string.try(:[], -2..-1).try(:to_i)
          year = year_int + (year_int < 70 ? 2000 : 1900)
        end

        return month, year
      end

      def six_digit_date(string)
        if string.try(:first).try(:to_i) > 1 #yyyymm
          month = string.try(:[], -2..-1).try(:to_i)
          year = string.try(:to_s).try(:[], 0..3).try(:to_i)
        else #mmyyyy
          month = string.try(:to_s).try(:[], 0..1).try(:to_i)
          year = string.try(:[], -4..-1).try(:to_i)
        end

        return month, year
      end

      def seven_digit_date(string)
        if string.try(:first).try(:to_i) > 1 #yyyymmm
          month_string = string.try(:[], -3..-1)
          month = month_int_from_string(month_string)
          year = string.try(:to_s).try(:[], 0..3).try(:to_i)
        else #mmmyyyy
          month_string = string.try(:to_s).try(:[], 0..2)
          month = month_int_from_string(month_string)
          year = string.try(:[], -4..-1).try(:to_i)
        end

        return month, year
      end

      def date_string_to_promo_dates(date_string)
        month, year = format_month_year(date_string)
        return nil if month.nil? || year.nil? || !(1..13).to_a.include?(month)
        {
          'start_date' => date_formatted_promo(year, month, 1) || nil,
          'end_date' => date_formatted_promo(year, month, -1) || nil
        }
      end

      def get_meta_data(document)
        get_raw_data(document,'meta_data').map { |row| row.join(' ') }
      end

      def get_totals(document)
        parsed_data(document, 'totals', false)
      end

      def get_customer_data(document)
        parsed_data(document, 'customer')
      end

      def get_invoice_date(document)
        parsed_data(document, 'invoice_date')
      end

      def get_invoice_number(document)
        parsed_data(document, 'invoice_number')
      end

      def parsed_data(document, key_field, single_output = true)
        row = get_raw_data(document, key_field).try(:flatten) || []
        single_output ? row.try(:first).try(:strip) : row
      end

      def get_total_in_dollars(amounts_arr, regex)
        return nil if !amounts_arr
        amount_row = string_match_from_arr(amounts_arr, regex)
        amount_str = string_match(amount_row, /\$?\d*(\.|\s|\,)?\d+\.?\d*/)
        str_to_dollars(amount_str)
      end

      def titleize_with_spaces(string)
        return string if string.try(:match?, /[A-Z]{3}/)
        result = ''
        no_whitespace = string.try(:scan,/\S+/).try(:join,'')
        no_whitespace.try(:split, '').each do |ch|
          ch = ' ' + ch if ch.match?(/([A-Z]|\/)/)
          result += ch
        end
        result.try(:strip)
      end

      def parsed_invoice_date(document)
        date = get_invoice_date(document)
        {'invoice_date' => date}
      end

      def replace_year(date_string, year)
        month_day = date_string.try(:scan, /^\d{1,4}\/\d{1,4}/).try(:first)
        month_day + '/' +  year
      end
    end
  end
end
