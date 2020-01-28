module Parsers
  module Helpers
    module GlobalSanitizers
      MONTHS_LIST =  %w(jan feb mar apr may jun jul aug sep oct nov dec)

      def str_to_dollars(str_amount)
        return nil if !str_amount
        amount = str_amount.to_s.try(:gsub,/(\,|\$|\s)/,'')
        dollar_cent_split = amount.try(:split, /(\.|\s)/)
        cents_str = dollar_cent_split.try(:length) == 3 ? dollar_cent_split.try(:last) : 0
        cents_str += '0' if cents_str.try(:length) == 1
        dollar_str = dollar_cent_split.try(:first) || 0
        return '' if !cents_str && !dollar_str
        (dollar_str.to_f) + (cents_str.to_f / 100)
      end

      def pattern_match_currency(string)
        string.try(:scan, /\$\d+,?\d*,?\d*,?\d*,?\d*\.?,?\d*/i).try(:flatten).try(:first)
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
        regex_match = string.try(:to_s).try(:match, regex)
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
        return nil if !string
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

      def date_to_string(date)
        date.try(:strftime, '%m/%d/%Y')
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
        month = month.try(:gsub, /^O/, '') if month.class == String #remove leading letter "O"s
        return nil if month.nil? || year.nil? || !(1..13).to_a.include?(month.try(:to_i))
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
        amount_row = amount_row.gsub(/\s*/, '')
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

      def date_b_year_cutoff(date_a, date_b)
        date_a_year_digits = date_a.try(:scan, /\d+$/).try(:first)
        date_b_year_digits = date_b.try(:scan, /\d+$/).try(:first)
        if !!date_a_year_digits && !!date_b_year_digits && date_b_year_digits.try(:length) < date_a_year_digits.try(:length)
          date_b = replace_year(date_b, date_a_year_digits)
        end

        date_b
      end

      def add_years_missing_from_two_dates(date_a, date_b) #for 'slash' dates (ex. mm/dd/yyyy or mm/dd format)
        if !date_a || !date_b
          return [date_a, date_b]
        elsif full_date?(date_b) && full_date?(date_a)
          return [date_a, date_b]
        elsif full_date?(date_b) && !full_date?(date_a)
          year = date_b.try(:split, '/').try(:last)
          date_a = date_a + "/#{year}"
        elsif full_date?(date_a) && !full_date?(date_b)
          year = date_a.try(:split, '/').try(:last)
          date_b = date_b + "/#{year}"
        else
          date_a = add_years_missing_from_date(date_a)
          year = date_a.try(:split, '/').try(:last)
          date_b = date_b + "/#{year}"
        end

        [date_a, date_b]
      end

      def add_years_missing_from_date(date) #for 'slash' dates (ex. mm/dd/yyyy or mm/dd format)
        today_year = Date.today.year
        try_date = date + "/#{today_year}"
        today_year -= 1 if future_date?(try_date)
        date + "/#{today_year}"
      end

      def future_date?(date_string)
        Date.today < Date.parse(date_string)
      end

      def full_date?(date_string)
        date_string.try(:match?, /\d{1,4}\/\d{1,4}\/\d{1,4}/)
      end

    end
  end
end
