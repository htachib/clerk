module Mappers
  class KeheHomestoreBillingChargebackInvoice < Base
    class << self
      def prepare_rows(raw_rows)
        prepared_row = OutputHeaders::ROW_FIELDS.deep_dup
        prepared_row['Customer'] = 'KeHE'
        prepared_row['Parser'] = 'KeHE Homestore Billing Chargeback / Invoice'
        file_name = raw_rows['file_name'].try(:gsub,'.pdf','').try(:gsub,'.PDF','')
        prepared_row['File Name'] = file_name
        prepared_row['Invoice Number'] = raw_rows['invoice_number']
        prepared_row['Deduction Post Date'] = Date.parse(raw_rows['uploaded_at']).strftime("%m/%d/%Y")
        prepared_row['Promo End Date'] = raw_rows['end_date']
        prepared_row['Promo Start Date'] = raw_rows['start_date']
        parser_lookup = get_parser_lookup(prepared_row['Parser'])
        prepared_row['Deduction Type'] = parser_lookup['Deduction Type']
        prepared_row['Deduction Description'] = parser_lookup['Deduction Description']
        prepared_row['Customer Chain ID'] = raw_rows['customer_chain']
        prepared_row['Customer Detailed Name'] = raw_rows['customer_chain']
        retail_chain_name_lookup = get_retail_chain_name_lookup(prepared_row['Customer Chain ID'])
        prepared_row['Retail Chain Name'] = retail_chain_name_lookup['Retail Chain Name']
        planning_retailer_lookup = get_planning_retailer_lookup(prepared_row['Retail Chain Name'])
        prepared_row['Planning Retailer'] = planning_retailer_lookup['Planning Retailer']
        deduction_type_lookup = get_deduction_type_lookup(prepared_row['Deduction Type'])
        prepared_row['Deduction Category'] = deduction_type_lookup['Deduction Category']
        prepared_row['Deduction Account'] = deduction_type_lookup['Deduction Account']
        prepared_row['Chargeback Amount'] = raw_rows['chargeback_amount']
        prepared_row['EP / Admin Fee'] = raw_rows['ep_fee']
        prepared_row['Variable Rate Per Unit'] = set_variable_rate(prepared_row)
        prepared_row.values # => [['asdf', 'asdf', 'asdf']]
      end
    end
  end
end
