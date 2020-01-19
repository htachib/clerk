module Mappers
  module Helpers
    module GlobalSanitizers

      def set_variable_rate(prepared_row)
        chargeback_amount_str = prepared_row['Chargeback Amount'] || 0
        ep_fee_str = prepared_row['EP / Admin Fee'] || 0
        shipped_str = prepared_row['Shipped'] || 0

        chargeback_amount = str_to_dollars(chargeback_amount_str)
        ep_fee = str_to_dollars(ep_fee_str)
        shipped = str_to_dollars(shipped_str)

        shipped == 0 || shipped == '' ? 0 : (chargeback_amount.to_f - ep_fee.to_f) / shipped.to_f
      end

      def str_to_dollars(str_amount)
        return nil if !str_amount
        amount = str_amount.to_s.try(:gsub,/(\,|\$)/,'')
        dollar_cents_arr = amount.split(/(\.|\s)/).select{ |str| str.match?(/\d/) }
        if dollar_cents_arr
          if dollar_cents_arr.length == 2
            return (dollar_cents_arr.first.to_f) + (dollar_cents_arr.last.to_f / 100)
          elsif dollar_cents_arr.length == 1
            return (dollar_cents_arr.first.to_f)
          else
            return ''
          end
        end
      end
    end
  end
end
