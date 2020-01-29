module Parsers
  class UnfiEastReclaimVendorChargebackReport < Base
    class << self
      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document))
      end

      def get_content_rows(document)
        content = document.try(:[], 'content')
        content.try(:split, "\n")
      end

      def parsed_invoice_number(document)
        rows = get_content_rows(document)
        match_row = rows.select { |r| r.try(:match?, /total\s*reclaim\s*credit/i) }.try(:first)
        invoice_number = match_row.try(:gsub, /^\s*/, '').try(:gsub, /total\s*reclaim\s*credit.*/i, '').try(:gsub, /\s*$/, '')
        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_date(document)
        rows = get_content_rows(document)
        match_row = rows.select { |r| r.try(:match?, /period\s*ending/i) }.try(:first)
        invoice_date = match_row.try(:scan, /\d{1,4}\/\d{1,4}\/\d{1,4}/).try(:first)

        {
          'start_date' => invoice_date,
          'end_date' => invoice_date
        }
      end

      def parsed_totals(document)
        rows = get_content_rows(document)
        match_row = rows.select { |r| r.try(:match?, /vendor\s*total/i) }.try(:first)
        chargeback_amount = match_row.try(:scan, /\d*\,?\d*\,?\d*\,?\d+\.?\d*/).try(:first)

        { 'chargeback_amount' => chargeback_amount }
      end
    end
  end
end
