module Mappers
  class UNFIWestWeeklyMCB < Base
    class << self

      def prepare_rows(raw_rows)
        raw_rows.map do |raw_row|
          prepared_row = OutputHeaders::ROW_FIELDS.deep_dup
          prepared_row['Customer'] = 'UNFI West'
          prepared_row['Parser'] = 'UNFI West Weekly MCB'
          file_name = raw_row['file_name'].try(:gsub,'.pdf','')
          prepared_row['File Name'] = file_name
          invoice_number = get_invoice_number(file_name)
          prepared_row['Invoice Number'] = invoice_number
          prepared_row['Deduction Post Date'] = Date.parse(raw_row['uploaded_at']).strftime("%m/%d/%Y")
          prepared_row['Promo End Date'] = raw_row['end_date']
          prepared_row['Promo Start Date'] = raw_row['start_date']
          mcb_rate = raw_row['MCB%']
          deduction_description = raw_row['MCB Category']
          prepared_row['Deduction Type'] = deduction_type_mapping(mcb_rate, deduction_description)
          prepared_row['Deduction Description'] = deduction_description
          prepared_row['Customer Chain ID'] = raw_row['abbreviation']
          prepared_row['Customer Detailed Name'] = raw_row['details']
          prepared_row['Chargeback Amount'] = raw_row['MCB']
          prepared_row['Customer Number'] = raw_row['id']
          prepared_row['Customer Location'] = raw_row['location']
          prepared_row['Customer City'] = raw_row['city']
          prepared_row['Customer State'] = raw_row['state']
          prepared_row['Brand'] = raw_row['Brand']
          prepared_row['Product'] = raw_row['Product']
          prepared_row['Unit'] = raw_row['Unit']
          prepared_row['Description'] = raw_row['Description']
          prepared_row['Invoice'] = raw_row['Invoice']
          prepared_row['Ordered'] = raw_row['Ordered']
          prepared_row['Shipped'] = raw_row['Shipped']
          prepared_row['Whlse'] = raw_row['Whlse']
          prepared_row['Total Discount%'] = raw_row['Total Discount%']
          prepared_row['MCB%'] =
          prepared_row['Variable Rate Per Unit'] = set_variable_rate(prepared_row)

          prepared_row.values # => [['asdf', 'asdf', 'asdf']]
        end
      end

      def get_invoice_number(input)
        file_name = input.split(' ')[0]
      end

      def deduction_type_mapping(mcb_rate, deduction_description)
        sanitized_description = deduction_description.downcase.gsub(/\s+/, '')
        mcb_rate_float = (mcb_rate.to_f) / 100
        if sanitized_description.include?('newadditions')
          return 'Free Fill'
        elsif sanitized_description.include?('newstoreopening/placement')
          return 'Free Fill'
        elsif sanitized_description.include?('samples')
          return 'Samples'
        elsif mcb_rate_float < 0.5
          return 'MCB'
        elsif mcb_rate_float >= 0.5
          return 'Free Fill'
        else
          return 'Undetermined'
        end
      end

    end
  end
end
