module Mappers
  class KeHePassThroughPromotion
    class << self
      def prepare_rows(raw_rows)
        prepared_row = OutputHeaders::ROW_FIELDS
        prepared_row['Customer'] = 'KeHe'
        prepared_row['Parser'] = 'KeHe Pass Through Promotion'
        file_name = raw_rows['file_name'].gsub('.pdf','').gsub('.PDF','')
        prepared_row['File Name'] = file_name
        prepared_row['Invoice Number'] = raw_rows['invoice number']
        prepared_row['Deduction Post Date'] = Date.parse(raw_rows['uploaded_at']).strftime("%m/%d/%Y")
        date_range = raw_rows['invoice_details'].first['date_range']
        start_date, end_date = get_promo_date(date_range)
        prepared_row['Promo End Date'] = start_date
        prepared_row['Promo Start Date'] = end_date
        prepared_row['Deduction Type'] = raw_rows['Type']
        prepared_row['Customer Chain ID'] = 'KeHe'
        prepared_row['Customer Detailed Name'] = 'KeHe'
        prepared_row['Chargeback Amount'] = raw_rows['chargeback_amount']
        prepared_row['EP Fee'] = raw_rows['ep_fee']
        prepared_row.values # => [['asdf', 'asdf', 'asdf']]
      end

      def get_promo_date(range)
        start_range, end_range = range.scan(/\d+\/\d+\/\d+/)
        end_year = end_range.scan(/\d+$/)[0]
        if end_year.to_i < 2000
          start_year = start_range.scan(/\d+$/)[0]
          end_range = end_range.scan(/^\d+\/\d+/)[0] + '/' + start_year
        end
        [start_range, end_range]
      end
    end
  end
end
