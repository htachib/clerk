module Mappers
  class UNFIEastDeductionInvoice
    class << self

      def prepare_rows(raw_rows)
        raw_rows.map do |raw_row|
          prepared_row = OutputHeaders::ROW_FIELDS
          prepared_row['Customer'] = 'UNFI East'
          prepared_row['Parser'] = 'UNFI East Deduction Invoice'
          prepared_row['File Name'] = raw_row['file_name'].gsub('.pdf','')
          prepared_row['Invoice Number'] = raw_row['deduction_num']
          prepared_row['Deduction Post Date'] = ''
          performance_dates = raw_row['performance_dates']
          prepared_row['Promo Start Date'] = get_promo_start_date(performance_dates)
          prepared_row['Promo End Date'] = get_promo_end_date(performance_dates)
          billing_desc = raw_row['billing_desc']
          prepared_row['Deduction Type'] = get_deduction_type(billing_desc)
          prepared_row['Deduction Description'] = billing_desc
          prepared_row['Customer Chain ID'] = 'UNFI East'
          prepared_row['Customer Detailed Name'] = 'UNFI East'
          amount = raw_row['amount']
          prepared_row['Chargeback Amount'] = amount.gsub(/[^\d\.]/, '').to_f
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
        type = input.split(/\d\s/).last
        case input
        when 'Ad Agreements'
          'Ad Fee'
        end
        # add others as identified
      end

    end
  end
end
