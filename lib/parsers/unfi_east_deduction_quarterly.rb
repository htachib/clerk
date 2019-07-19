module Parsers
  class UNFIEastDeductionQuarterly < Base
    class << self
      def parse_rows(document)
        row = document['meta_data'].try(:[], 0).deep_merge(
          'file_name' => document['file_name']
        ).deep_merge(
          'uploaded_at' => document['uploaded_at']
        ).deep_merge(
          parsed_amount(document)
        ).deep_merge(
          parsed_invoice_summary(document)
        ).deep_merge(
          parsed_invoice_date(document)
        )

        [row]
      end

      def parsed_invoice_date(document)
        start_date, end_date = document.try(:[], 'meta_data').try(:first).try(:[], 'invoice_date')
        {'start_date' => start_date,
          'end_date' => end_date}
      end

      def parsed_invoice_summary(document)
        data = document.try(:[], 'invoice_summary_option_1')
        rows = data.try(:last)
        {'billing_desc' => rows.try(:[], 'key_2')}
      end

      def parsed_amount(document)
        amount = document.try(:[], 'amount').try(:first).try(:values).try(:first)
        {'amount' => amount}
      end
    end
  end
end
