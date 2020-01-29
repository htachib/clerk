module Parsers
  class UnfiEastReclaimVendorChargebackReport < Base
    class << self
      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document))
      end

      def txt_file?(document)
        content = document.try(:[], 'content')
        !!content
      end

      def parsed_invoice_date(document)
        invoice_date = txt_file?(document) ? txt_parsed_invoice_date(document) : pdf_parsed_invoice_date(document)
        {
          'start_date' => invoice_date,
          'end_date' => invoice_date,
        }
      end

      def parsed_totals(document)
        chargeback_amount = txt_file?(document) ? txt_parsed_totals(document) : pdf_parsed_totals(document)
        { 'chargeback_amount' => chargeback_amount }
      end

      def parsed_invoice_number(document)
        invoice_number = txt_file?(document) ? txt_parsed_invoice_number(document) : pdf_parsed_invoice_number(document)
        {'invoice_number' => invoice_number}
      end

      def get_content_rows(document)
        content = document.try(:[], 'content')
        content.try(:split, "\n")
      end

      def txt_parsed_invoice_number(document)
        rows = get_content_rows(document)
        match_row = rows.select { |r| r.try(:match?, /total\s*reclaim\s*credit/i) }.try(:first)
        match_row.try(:gsub, /^\s*/, '').try(:gsub, /total\s*reclaim\s*credit.*/i, '').try(:gsub, /\s*$/, '')
      end

      def txt_parsed_invoice_date(document)
        rows = get_content_rows(document)
        match_row = rows.select { |r| r.try(:match?, /period\s*ending/i) }.try(:first)
        match_row.try(:scan, /\d{1,4}\/\d{1,4}\/\d{1,4}/).try(:first)
      end

      def txt_parsed_totals(document)
        rows = get_content_rows(document)
        match_row = rows.select { |r| r.try(:match?, /vendor\s*total/i) }.try(:first)
        match_row.try(:scan, /\d*\,?\d*\,?\d*\,?\d+\.?\d*/).try(:first)
      end

      def pdf_parsed_invoice_number(document)
        get_invoice_number(document)
      end

      def pdf_parsed_invoice_date(document)
        get_invoice_date(document)
      end

      def pdf_parsed_totals(document)
        get_totals(document).try(:first)
      end
    end
  end
end
