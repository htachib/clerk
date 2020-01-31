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
        amount = str_amount.to_s.try(:gsub,/(\,|\$|\s)/,'')
        dollar_cent_split = amount.try(:split, /(\.|\s)/)
        cents_str = dollar_cent_split.try(:length) == 3 ? dollar_cent_split.try(:last) : 0
        cents_str += '0' if cents_str.try(:gsub, /\W*/i, '').try(:length) == 1
        dollar_str = dollar_cent_split.try(:first).try(:gsub, /\W*/i, '') || 0
        return '' if !cents_str && !dollar_str
        (dollar_str.to_f) + (cents_str.to_f / 100)
      end
    end
  end
end
