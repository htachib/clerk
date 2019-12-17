module Parsers
  module Helpers
    module GlobalSanitizers
      MONTHS_LIST =  %w(jan feb mar apr may jun jul aug sep oct nov dec)

      def str_to_dollars(str_amount)
        return nil if !str_amount
        amount = str_amount.to_s.try(:gsub,/(\,|\$)/,'')
        dollar_cents_arr = amount.split(/(\.|\s)/).select{ |str| str.match?(/\d/) }
        if dollar_cents_arr && dollar_cents_arr.length == 2
          return (dollar_cents_arr.first.to_f) + (dollar_cents_arr.last.to_f / 100)
        else
          return ''
        end
      end

      def get_amount_str(totals_arr)
        totals_arr ? totals_arr.match(/\$(\d|\,|\.){1,}/).try(:[], 0).try(:gsub,'$','') : nil
      end

      def invoice_num_from_file_name(document)
        document['file_name'].split(' ').first.match(/([a-zA-Z]|\d){5,}/).try(:[], 0)
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

      def format_month_year(digits)
        return nil unless [4, 5, 6, 7].include?(digits.to_s.length)

        case digits.to_s.length
        when 4 #mmyy
          month = digits.try(:to_s).try(:[], 0..1)
          year_int = digits.try(:[], -2..-1).try(:to_i)
          year = year_int + (year_int < 70 ? 2000 : 1900)
        when 5 #mmmyy
          month_string = digits.try(:to_s).try(:[], 0..2)
          month = month_int_from_string(month_string)
          year_int = digits.try(:[], -2..-1).try(:to_i)
          year = year_int + (year_int < 70 ? 2000 : 1900)
        when 6 #mmyyyy
          month = digits.try(:to_s).try(:[], 0..1)
          year = digits.try(:[], -4..-1).try(:to_i)
        when 7 #mmmyyyy
          month_string = digits.try(:to_s).try(:[], 0..2)
          month = month_int_from_string(month_string)
          year = digits.try(:[], -4..-1).try(:to_i)
        end

        return month, year
      end

      def date_string_to_promo_dates(date_string)
        month, year = format_month_year(date_string)
        {
          'start_date' => date_formatted_promo(year.to_i, month.to_i, 1) || nil,
          'end_date' => date_formatted_promo(year.to_i, month.to_i, -1) || nil
        }
      end
    end
  end
end
