module Mappers
  class DpiSpoilage < Base
    class << self

      def prepare_rows(raw_rows)
        raw_rows.map do |raw_row|
          prepared_row = OutputHeaders::ROW_FIELDS.deep_dup
          prepared_row['Customer'] = 'DPI'
          prepared_row['Parser'] = 'DPI Spoilage'
          prepared_row['File Name'] = raw_row['file_name']
          prepared_row['Invoice Number'] = raw_row['AP Invoice Number']
          next if prepared_row['Invoice Number'].try(:empty?)
          prepared_row['Deduction Post Date'] = raw_row['uploaded_at']
          promo_end_date = raw_row['Trx Date']
          prepared_row['Promo End Date'] = format_date_year(promo_end_date)
          prepared_row['Promo Start Date'] = format_date_year(promo_end_date)
          parser_lookup = get_parser_lookup(prepared_row['Parser'])
          prepared_row['Deduction Type'] = parser_lookup['Deduction Type']
          prepared_row['Deduction Description'] = raw_row['Billback Reason']
          deduction_type_lookup = get_deduction_type_lookup(prepared_row['Deduction Type']) if prepared_row['Deduction Type']
          prepared_row['Deduction Category'] = deduction_type_lookup['Deduction Category'] if deduction_type_lookup
          prepared_row['Deduction Account'] = deduction_type_lookup['Deduction Account'] if deduction_type_lookup
          prepared_row['Customer Chain ID'] = raw_row['Customer Name']
          prepared_row['Customer Detailed Name'] = raw_row['Account Name']
          retail_chain_name_lookup = get_retail_chain_name_lookup(prepared_row['Customer Chain ID']) if prepared_row['Customer Chain ID']
          prepared_row['Retail Chain Name'] = retail_chain_name_lookup['Retail Chain Name'] if retail_chain_name_lookup
          planning_retailer_lookup = get_planning_retailer_lookup(prepared_row['Retail Chain Name']) if prepared_row['Retail Chain Name']
          prepared_row['Planning Retailer'] = planning_retailer_lookup['Planning Retailer'] if planning_retailer_lookup
          chargeback_amount = raw_row['Amount'].try(:to_f).try(:abs)
          prepared_row['Chargeback Amount'] = chargeback_amount
          prepared_row['Shipped'] = raw_row['QTY'] || raw_row['Qty'] || raw_row['qty']
          prepared_row['Variable Rate Per Unit'] = set_variable_rate(prepared_row)
          prepared_row.values # => [["UNFI East", "UNFI East Weekly MCB Report", "WE 2018-08-11 51304CASAD"]]
        end
      end

      def format_date_year(input = nil)
        return nil if input.blank?
        date = Date.parse(input)
        date.try(:strftime, '%m/%d/%Y')
      end
    end
  end
end
