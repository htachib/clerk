module Mappers
  class KeheWeeklyMCB
    class << self

      def prepare_rows(raw_rows)
        raw_rows.map do |raw_row|
          prepared_row = OutputHeaders::ROW_FIELDS.deep_dup
          prepared_row['Customer'] = 'KeHE'
          prepared_row['Parser'] = 'KeHE Weekly MCB Report'
          file_name = raw_row['file_name'].try(:gsub,'.pdf','').try(:gsub,'.PDF','')
          prepared_row['File Name'] = file_name
          prepared_row['Invoice Number'] = file_name.split('-').first
          prepared_row['Deduction Post Date'] = Date.parse(raw_row['uploaded_at']).strftime("%m/%d/%Y")
          prepared_row['Promo End Date'] = raw_row['end_date']
          prepared_row['Promo Start Date'] = raw_row['start_date']
          prepared_row['Customer Detailed Name'] = raw_row['SEND TO'] || ''
          prepared_row['Chargeback Amount'] = raw_row['EXT-COST'] || raw_row['processing_fee']
          prepared_row['Customer Number'] = raw_row['Customer ID'] || ''
          prepared_row['Customer Location'] = [raw_row['ADDRESS'], raw_row['city'], raw_row['state']].join(' ') || ''
          prepared_row['Customer City'] = raw_row['city'] || ''
          prepared_row['Customer State'] = raw_row['state'] || ''
          prepared_row['Description'] = raw_row['DESCRIPTION'] || ''
          prepared_row['Shipped'] = raw_row['QTY SHIP'] ? raw_row['QTY SHIP'].to_f / 6 : ''
          prepared_row['Total Discount%'] = raw_row['DISC $ OR %'] || ''
          whlse = raw_row['COST'].to_f * raw_row['QTY SHIP'].to_f
          prepared_row['Whlse'] = raw_row['COST'] ? format("$%.2f", whlse) : ''
          mcb = raw_row['EXT-COST'].to_f / whlse
          formatted_mcb = format('%.2f', mcb * 100) + '%'
          prepared_row['MCB%'] = raw_row['EXT-COST'] ? formatted_mcb : ''
          prepared_row['Deduction Type'] = raw_row['EXT-COST'] ? 'MCB - ' + formatted_mcb : 'Processing Fee'
          prepared_row['TOL User'] = raw_row['TOL User'] || ''
          prepared_row['UPC'] = raw_row['UPC#'] || ''
          prepared_row['Reference Number'] = raw_row['REFERENCE NBR'] || ''
          prepared_row['Reference Date'] = raw_row['REFERENCE DATE'] || ''
          prepared_row['KeHE Comment'] = raw_row['COMMENT'] || ''

          prepared_row.values # => [['asdf', 'asdf', 'asdf']]
        end
      end
    end
  end
end
