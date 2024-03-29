module Mappers
  class KeheNonserviceInStoreCredits < Base
    class << self
      def prepare_rows(raw_rows)
        prepared_row = OutputHeaders::ROW_FIELDS.deep_dup
        prepared_row['Customer'] = 'KeHE'
        prepared_row['Parser'] = 'KeHE Non-Service In Store Credits'
        file_name = raw_rows['file_name'].try(:gsub,'.pdf','').try(:gsub,'.PDF','')
        prepared_row['File Name'] = file_name
        prepared_row['Invoice Number'] = raw_rows['invoice_number']
        prepared_row['Deduction Post Date'] = Date.parse(raw_rows['uploaded_at']).strftime("%m/%d/%Y")
        prepared_row['Promo End Date'] = raw_rows['end_date']
        prepared_row['Promo Start Date'] = raw_rows['start_date']
        prepared_row['Deduction Type'] = raw_rows['type']
        prepared_row['Deduction Description'] = raw_rows['deduction_description']
        prepared_row['Customer Chain ID'] = raw_rows['detailed_customer']
        prepared_row['Customer Detailed Name'] = raw_rows['detailed_customer']
        prepared_row['Chargeback Amount'] = raw_rows['chargeback_amount']
        prepared_row['EP / Admin Fee'] = raw_rows['ep_fee']
        prepared_row['Variable Rate Per Unit'] = set_variable_rate(prepared_row)
        prepared_row.values # => [['asdf', 'asdf', 'asdf']]
      end
    end
  end
end
