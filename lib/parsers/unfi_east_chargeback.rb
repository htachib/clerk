module Parsers
  class UNFIEastChargeback
    class << self
      def parse_rows(document)
        row = document['meta_data'][0].deep_merge(
          'file_name' => document['file_name']
        ).deep_merge(
          'uploaded_at' => document['uploaded_at']
        ).deep_merge(
          document['deduction_type'][0]
        ).deep_merge(
          document['chargeback_amount'][0]
        )

        [row]
      end
    end
  end
end
