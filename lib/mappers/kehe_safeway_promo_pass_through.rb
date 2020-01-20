module Mappers
  class KeheSafewayPromoPassThrough < Base
    class << self
      def prepare_rows(raw_rows)
        raw_rows.map do |raw_row|
          prepared_row = OutputHeaders::ROW_FIELDS.deep_dup
          prepared_row['Customer'] = 'KeHE'
          prepared_row['Parser'] = "KeHE Safeway Promo Pass Through"
          file_name = raw_row['file_name'].try(:gsub,'.pdf','').try(:gsub,'.PDF','')
          prepared_row['File Name'] = file_name
          prepared_row['Invoice Number'] = raw_row['invoice_number']
          prepared_row['Deduction Post Date'] = Date.parse(raw_row['uploaded_at']).strftime("%m/%d/%Y")
          prepared_row['Promo End Date'] = raw_row['end_date']
          prepared_row['Promo Start Date'] = raw_row['start_date']
          deduction_description = raw_row['deduction_description']
          prepared_row['Deduction Description'] = deduction_description
          deduction_type = deduction_description.match?(/(^flat|^ep fee - flat)/i) ? 'Ad Fee' : 'MCB'
          prepared_row['Deduction Type'] = deduction_type
          parser_lookup = get_parser_lookup(prepared_row['Parser'])
          prepared_row['Customer Chain ID'] = parser_lookup['Customer Chain ID']
          prepared_row['Customer Detailed Name'] = parser_lookup['Customer Detailed Name']
          retail_chain_name_lookup = get_retail_chain_name_lookup(prepared_row['Customer Chain ID']) if prepared_row['Customer Chain ID']
          prepared_row['Retail Chain Name'] = retail_chain_name_lookup['Retail Chain Name'] if retail_chain_name_lookup
          planning_retailer_lookup = get_planning_retailer_lookup(prepared_row['Retail Chain Name']) if prepared_row['Retail Chain Name']
          prepared_row['Planning Retailer'] = planning_retailer_lookup['Planning Retailer'] if planning_retailer_lookup
          deduction_type_lookup = get_deduction_type_lookup(prepared_row['Deduction Type']) if prepared_row['Deduction Type']
          prepared_row['Deduction Category'] = deduction_type_lookup['Deduction Category'] if deduction_type_lookup
          prepared_row['Deduction Account'] = deduction_type_lookup['Deduction Account'] if deduction_type_lookup
          prepared_row['Chargeback Amount'] = raw_row['chargeback_amount']
          prepared_row['EP / Admin Fee'] = raw_row['ep_fee']
          prepared_row['Variable Rate Per Unit'] = set_variable_rate(prepared_row)
          prepared_row['Product'] = raw_row['upc']
          prepared_row['Description'] = raw_row['product_information']
          prepared_row['Customer Location'] = raw_row['customer_location']
          prepared_row.values # => [['asdf', 'asdf', 'asdf']]
        end
      end
    end
  end
end