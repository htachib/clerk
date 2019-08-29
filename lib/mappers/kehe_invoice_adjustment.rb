module Mappers
  class KeheInvoiceAdjustment
    class << self
      def prepare_rows(raw_rows)
        prepared_row = OutputHeaders::ROW_FIELDS.deep_dup
        prepared_row['Customer'] = 'KeHE'
        prepared_row['Parser'] = 'KeHE Invoice Adjustment'
        file_name = raw_rows['file_name'].try(:gsub,'.pdf','').try(:gsub,'.PDF','')
        prepared_row['File Name'] = file_name
        prepared_row['Invoice Number'] = raw_rows['invoice number']
        prepared_row['Deduction Post Date'] = Date.parse(raw_rows['uploaded_at']).strftime("%m/%d/%Y")
        prepared_row['Promo End Date'] = raw_rows['invoice_date']
        prepared_row['Promo Start Date'] = raw_rows['start_date']
        prepared_row['Deduction Type'] = 'Invoice Adjustment'
        prepared_row['Deduction Description'] = ''
        prepared_row['Customer Chain ID'] = 'KeHe'
        prepared_row['Customer Detailed Name'] = 'KeHe'
        prepared_row['Chargeback Amount'] = raw_rows['chargeback_amount']
        prepared_row.values # => [['asdf', 'asdf', 'asdf']]
      end
    end
  end
end
