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
    end
  end
end
