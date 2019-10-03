module Mappers
  class UNFIEastDeductionQuarterly
    class << self

      def prepare_rows(raw_rows)
        raw_rows.map do |raw_row|
          prepared_row = OutputHeaders::ROW_FIELDS.deep_dup
          prepared_row['Customer'] = 'UNFI East'
          prepared_row['Parser'] = 'UNFI East Deduction Quarterly'
          prepared_row['File Name'] = raw_row['file_name'].try(:gsub,'.pdf','')
          prepared_row['Invoice Number'] = raw_row['deduction_num']
          prepared_row['Deduction Post Date'] = Date.parse(raw_row['uploaded_at']).strftime("%m/%d/%Y")
          prepared_row['Promo Start Date'] = raw_row['start_date']
          prepared_row['Promo End Date'] = raw_row['end_date']
          billing_desc = raw_row['billing_desc']
          prepared_row['Deduction Type'] = get_deduction_type(billing_desc)
          prepared_row['Deduction Description'] = billing_desc
          prepared_row['Customer Chain ID'] = 'UNFI East'
          prepared_row['Customer Detailed Name'] = 'UNFI East'
          amount = raw_row['amount']
          prepared_row['Chargeback Amount'] = amount.try(:gsub,/[^\d\.]/,'').to_f
          prepared_row['Customer Number'] = ''
          prepared_row['Customer Location'] = ''
          prepared_row['Customer City'] = ''
          prepared_row['Customer State'] = ''

          prepared_row.values # => [['asdf', 'asdf', 'asdf']]
        end
      end

      def get_promo_start_date(input)
        Date.parse(input).strftime("%m/%d/%Y")
      end

      def get_promo_end_date(input)
        (Date.parse(input) + 2.months).end_of_month.strftime("%m/%d/%Y")
      end

      def get_deduction_type(input)
        type = input.try(:split, /\d\s/).try(:last)
        if !type
          'Ad Fee'
        elsif type == 'Ad Agreements'
          'Ad Fee'
        else
          type
        end
        # add others as identified
      end

    end
  end
end
