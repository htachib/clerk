module Parsers
  module Helpers
    module Sanitizer
      def str_to_dollars(str_amount)
        return nil if !str_amount
        dollar_cents_arr = str_amount.gsub(/\,/,'').split(/(\.|\s)/).select{ |str| str.match(/\d/) }

        if dollar_cents_arr && dollar_cents_arr.length == 2
          return (dollar_cents_arr.first.to_f) + (dollar_cents_arr.last.to_f / 100)
        else
          return 'Unable to Read'
        end
      end

      def get_amount_str(totals_arr)
        totals_arr ? totals_arr.match(/\$(\d|\,|\.){1,}/)[0].gsub('$','') : nil
      end

      def invoice_num_from_file_name(document)
        document['file_name'].split(' ').first
      end

      def invoice_date_from_file_name(document)
        date_str = document["file_name"].match(/\d{2,4}-\d{1,2}-\d{1,2}/)[0]
        sanitize_date_year_month_day(date_str)
      end

      def sanitize_date_year_month_day(string)
        substring = string.split('-')
        "#{substring[1]}/#{substring[2]}/#{substring[0]}"
      end
    end
  end
end
