module Mappers
  class UNFIWestWeeklyMCB
    class << self

      def prepare_rows(raw_rows)
        raw_rows.map do |raw_row|
          prepared_row = OutputHeaders::ROW_FIELDS
          prepared_row['Customer'] = 'UNFI West'
          prepared_row['Parser'] = 'UNFI West Weekly MCB Report'
          file_name = raw_row['file_name'].gsub('.pdf','')
          prepared_row['File Name'] = file_name
          invoice_number = get_invoice_number(file_name)
          prepared_row['Invoice Number'] = invoice_number
          prepared_row['Deduction Post Date'] = Date.parse(raw_row['uploaded_at']).strftime("%m/%d/%Y")
          promo_date = get_promo_date(invoice_number)
          promo_end_date = get_promo_end_date(promo_date)
          prepared_row['Promo End Date'] = promo_end_date
          prepared_row['Promo Start Date'] = get_promo_start_date(promo_date)
          prepared_row['Deduction Type'] = raw_row['MCB Category']
          prepared_row['Deduction Description'] = ''
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
          prepared_row['MCB%'] = raw_row['MCB%']

          prepared_row.values # => [['asdf', 'asdf', 'asdf']]
        end
      end

      def get_invoice_number(input)
        file_name = input.split(' ')[0]
      end

      def get_promo_start_date(input)
        date = input - 6.days
        date.strftime("%m/%d/%Y")
      end

      def get_promo_date(input)
        date_string = input.gsub('MCB', '')
        Date.strptime(date_string, '%Y%m%d')
      end

      def get_promo_end_date(input)
        input.strftime('%m/%d/%Y')
      end

    end
  end
end
