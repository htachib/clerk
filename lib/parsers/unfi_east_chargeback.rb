module Parsers
  class UnfiEastChargeback < Base
    class << self
      def parse_rows(document)
        row = document['meta_data'].try(:[], 0).deep_merge(
          'file_name' => document['file_name']
        ).deep_merge(
          'uploaded_at' => document['uploaded_at']
        ).deep_merge(
          'deduction_type' => document['deduction_type'].try(:[], 0).try(:[], 'deduction_type')
        ).deep_merge(
          'chargeback_amount' => document['chargeback_amount'].try(:[], 0).try(:[], 'chargeback_amount')
        )

        [row]
      end
    end
  end
end
