module Parsers
  module Helpers
    module Sanitizer
      def str_to_dollars(str_amount)
        dollar_cents_arr = str_amount.split(/(\.|\s)/).select{ |str| str.match(/\d/) }
        if dollar_cents_arr.length == 2
          return (dollar_cents_arr.first.to_f) + (dollar_cents_arr.last.to_f / 100)
        else
          return 'Unable to Read'
        end
      end
    end
  end
end
