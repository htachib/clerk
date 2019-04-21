module Parsers
  class UNFIEastDeductionInvoice
    class << self
      def parse_rows(document)
        row = document['meta_data'][0].deep_merge(
          'file_name' => document['file_name']
        ).deep_merge(
          'uploaded_at' => document['uploaded_at']
        ).deep_merge(
          document['amount'][0]
        ).deep_merge(
          document['invoice_summary'][0]
        )

        [row]
      end
    end
  end
end
