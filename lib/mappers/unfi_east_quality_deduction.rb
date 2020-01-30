module Mappers
  class UnfiEastQualityDeduction < Base
    class << self
      def prepare_rows(raw_rows)
        prepared_row = OutputHeaders::ROW_FIELDS.deep_dup
        prepared_row['Customer'] = 'UNFI East'
        prepared_row['Parser'] = "UNFI East Quality Deduction"
        file_name = raw_rows['file_name'].try(:gsub,'.pdf','').try(:gsub,'.PDF','')
        prepared_row['File Name'] = file_name
        prepared_row['Invoice Number'] = raw_rows['invoice_number']
        invoice_number_lookup = get_invoice_number_lookup(raw_rows['invoice_number']) if raw_rows['invoice_number']
        prepared_row['Deduction Post Date'] = Date.parse(raw_rows['uploaded_at']).strftime("%m/%d/%Y")
        prepared_row['Promo End Date'] = raw_rows['end_date']
        prepared_row['Promo Start Date'] = raw_rows['start_date']
        prepared_row['Deduction Type'] = invoice_number_lookup['Deduction Type']
        prepared_row['Deduction Description'] = invoice_number_lookup['Deduction Description']
        prepared_row['Customer Chain ID'] = invoice_number_lookup['Customer Chain ID']
        prepared_row['Customer Detailed Name'] = invoice_number_lookup['Customer Detailed Name']
        retail_chain_name_lookup = get_retail_chain_name_lookup(prepared_row['Customer Chain ID']) if prepared_row['Customer Chain ID']
        prepared_row['Retail Chain Name'] = retail_chain_name_lookup['Retail Chain Name'] if retail_chain_name_lookup
        planning_retailer_lookup = get_planning_retailer_lookup(prepared_row['Retail Chain Name']) if prepared_row['Retail Chain Name']
        prepared_row['Planning Retailer'] = planning_retailer_lookup['Planning Retailer'] if planning_retailer_lookup
        deduction_type_lookup = get_deduction_type_lookup(prepared_row['Deduction Type']) if prepared_row['Deduction Type']
        prepared_row['Deduction Category'] = deduction_type_lookup['Deduction Category'] if deduction_type_lookup
        prepared_row['Deduction Account'] = deduction_type_lookup['Deduction Account'] if deduction_type_lookup
        chargeback_amount = raw_rows['chargeback_amount']
        prepared_row['Chargeback Amount'] = raw_rows['chargeback_amount']
        prepared_row['Variable Rate Per Unit'] = set_variable_rate(prepared_row)
        prepared_row.values # => [['asdf', 'asdf', 'asdf']]
      end
    end
  end
end
