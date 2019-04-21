module Mappers
  class UNFIEastWeeklyMCB
    class << self

      def prepare_rows(raw_rows)
        raw_rows.map do |raw_row|
          prepared_row = OutputHeaders::ROW_FIELDS
          prepared_row['Customer'] = 'UNFI East'
          prepared_row['Parser'] = 'UNFI East Weekly MCB Report'
          prepared_row['File Name'] = '{{TBD}}'
          prepared_row['Invoice Number'] = raw_row['Invoice']
          prepared_row['Deduction Post Date'] = Date.parse(raw_row['uploaded_at']).strftime("%m/%d/%Y")
          promo_end_date = raw_row['Period End']
          prepared_row['Promo End Date'] = format_date_year(promo_end_date)
          prepared_row['Promo Start Date'] = get_promo_start_date(promo_end_date)
          prepared_row['Deduction Type'] = raw_row['MCB Category']
          prepared_row['Deduction Description'] = ''
          prepared_row['Customer Chain ID'] = raw_row['Chain']
          prepared_row['Customer Detailed Name'] = raw_row['Customer Name']
          prepared_row['Chargeback Amount'] = raw_row['MCB']
          prepared_row['Customer Number'] = raw_row['Cust #']
          prepared_row['Customer Location'] = [raw_row['City'], raw_row['State']].join(', ')
          prepared_row['Customer City'] = raw_row['City']
          prepared_row['Customer State'] = raw_row['State']
          prepared_row['Brand'] = raw_row['Brand']
          prepared_row['Product'] = raw_row['Prod #']
          prepared_row['Unit'] = raw_row['Pack/Size']
          prepared_row['Description'] = raw_row['Description']
          prepared_row['Invoice'] = raw_row['Inv#']
          prepared_row['Shipped'] = raw_row['QtyS']
          prepared_row['Whlse'] = raw_row['InvAmt']
          prepared_row['Total Discount%'] = ''
          prepared_row['MCB%'] = raw_row['ChgBckPct'] + '%'

          prepared_row.values # => [['asdf', 'asdf', 'asdf']]
        end
      end

      def get_promo_start_date(end_date)
        date = convert_date(end_date) - 6.days
        date.strftime("%m/%d/%Y")
      end

      def convert_date(input)
        Date.strptime(input, '%m/%d/%y')
      end

      def format_date_year(input)
        Date.strptime(input, '%m/%d/%y').strftime('%m/%d/%Y')
      end
    end
  end
end
