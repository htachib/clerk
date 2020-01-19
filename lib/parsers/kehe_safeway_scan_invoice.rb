module Parsers
  class KeheSafewayScanInvoice < Base
    class << self
      def parse_rows(document)
        rows = []
        row_count = document.try(:[], 'upc').count

        row_count.times do |row_idx|
          meta_data = parsed_meta_data(document)
          row_data = invoice_data(document, meta_data, row_idx)
          rows.push(row_data)
        end
        total_row_data = total_row(document, rows[0])
        rows.push(total_row_data)
      end

      def total_row(document, row)
        ep_row = row.clone
        ep_row['chargeback_amount'] = ep_fee(document)
        ep_row['ep_fee'] = ep_fee(document)

        deduction_description = ep_row['deduction_description']
        deduction_description = 'EP FEE - ' + deduction_description
        ep_row['deduction_description'] = deduction_description
        ep_row['shipped'] = nil
        ep_row['upc'] = nil
        ep_row['product_information'] = nil
        ep_row['customer_location'] = nil
        ep_row
      end

      def parsed_meta_data(document)
        parsed_invoice_number(document
        ).deep_merge('uploaded_at' => document['uploaded_at']
        ).deep_merge('file_name' => document['file_name'])
      end

      def invoice_data(document, meta_data, row_idx)
        meta_data.deep_merge(
        parsed_invoice_date(document, row_idx)).deep_merge(
        parsed_totals(document, row_idx)).deep_merge(
        parsed_deduction_description(document, row_idx)).deep_merge(
        parsed_upc(document, row_idx)).deep_merge(
        parsed_product_information(document, row_idx)).deep_merge(
        parsed_customer_location(document, row_idx))
      end

      def parsed_invoice_number(document)
        invoice_number = get_invoice_number(document)
        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_date(document, row_idx)
        invoice_dates = document.try(:[], 'invoice_date').try(:[], row_idx)
        {
          'start_date' => invoice_dates['start_date'],
          'end_date' => invoice_dates['end_date']
        }
      end

      def parsed_totals(document, row_idx)
        totals = get_totals(document)
        chargeback_amount = totals.try(:[], row_idx)
        { 'chargeback_amount' => chargeback_amount }
      end

      def parsed_deduction_description(document, row_idx)
        parsed = document.try(:[], 'deduction_description').try(:[], row_idx)
        deduction_description = parsed.try(:values).try(:first)
        shipped = deduction_description.try(:scan, /\d+\s*\@/i).try(:first).try(:scan, /\d+/i).try(:first)

        { 'deduction_description' => deduction_description,
          'shipped' => shipped }
      end

      def parsed_upc(document, row_idx)
        parsed = document.try(:[], 'upc').try(:[], row_idx)
        upc = parsed.try(:values).try(:first)
        { 'upc' => upc }
      end

      def parsed_product_information(document, row_idx)
        parsed = document.try(:[], 'product_information').try(:[], row_idx)
        product_information = parsed.try(:values).try(:first)
        { 'product_information' => product_information }
      end

      def parsed_customer_location(document, row_idx)
        parsed = document.try(:[], 'customer_location').try(:[], row_idx)
        customer_location = parsed.try(:values).try(:first)
        { 'customer_location' => customer_location }
      end

      def ep_fee(document)
        regex = /ep.*fee/i
        totals = parsed_data(document, 'ep_fee')
        get_total_in_dollars(totals, regex)
      end
    end
  end
end
