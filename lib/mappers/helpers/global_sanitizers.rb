module Mappers
  module Helpers
    module GlobalSanitizers

      def set_variable_rate(prepared_row)
        chargeback_amount = prepared_row['Chargeback Amount'] || 0
        ep_fee = prepared_row['EP Fee'] || 0
        shipped = prepared_row['Shipped'] || 0

        shipped == 0 ? '-- ' : (chargeback_amount.to_f - ep_fee.to_f) / shipped.to_f
      end

    end
  end
end
