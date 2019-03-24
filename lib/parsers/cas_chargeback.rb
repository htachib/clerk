module Parsers
  class CasChargeback
    class << self

      def parse_row(document)
        meta_data = document['meta_data'][0]
        invoice_details = document['invoice_details']

        invoice_details.map do |line_item|
          meta_data.deep_merge(line_item).values
        end
      end
    end
  end
end
