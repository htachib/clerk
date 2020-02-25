module Mappers
  module Helpers
    module GlobalSanitizers

      def set_variable_rate(prepared_row)
        chargeback_amount_str = prepared_row['Chargeback Amount'] || 0
        ep_fee_str = prepared_row['EP / Admin Fee'] || 0
        shipped_str = prepared_row['Shipped'] || 0

        chargeback_amount = chargeback_amount_str.to_dollars
        ep_fee = ep_fee_str.to_dollars
        shipped = shipped_str.to_dollars

        shipped == 0 || shipped == '' ? 0 : (chargeback_amount.to_f - ep_fee.to_f) / shipped.to_f
      end

      def add_flag_if_missing(row, fields_arr)
        fields_arr.each do |field|
          row[field] = 'Not Found' if row[field].blank?
        end
        row
      end
    end
  end
end
