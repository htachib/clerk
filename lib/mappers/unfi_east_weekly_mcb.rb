module Mappers
  class UnfiEastWeeklyMcb < Base
    class << self

      def prepare_rows(raw_rows)
        raw_rows.map do |raw_row|
          prepared_row = OutputHeaders::ROW_FIELDS.deep_dup
          prepared_row['Customer'] = 'UNFI East'
          prepared_row['Parser'] = 'UNFI East Weekly MCB'
          prepared_row['File Name'] = raw_row['file_name']
          prepared_row['Invoice Number'] = raw_row['Invoice']
          prepared_row['Deduction Post Date'] = raw_row['uploaded_at']
          promo_end_date = raw_row['Period End']
          prepared_row['Promo End Date'] = format_date_year(promo_end_date)
          prepared_row['Promo Start Date'] = get_promo_start_date(promo_end_date)
          deduction_description = raw_row['MCB Category']
          prepared_row['Deduction Description'] = deduction_description
          mcb_rate = "#{raw_row['ChgBckPct']}%"
          prepared_row['MCB%'] = mcb_rate
          prepared_row['Deduction Type'] = deduction_type_mapping(mcb_rate, deduction_description)
          detailed_name = raw_row['Customer Name']
          chain = raw_row['Chain']
          prepared_row['Customer Chain ID'] = sanitize_chain(chain, detailed_name)
          prepared_row['Customer Detailed Name'] = detailed_name
          prepared_row['Chargeback Amount'] = raw_row['ChgBckAmt']
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
          prepared_row['Variable Rate Per Unit'] = set_variable_rate(prepared_row)

          prepared_row.values # => [["UNFI East", "UNFI East Weekly MCB Report", "WE 2018-08-11 51304CASAD"]]
        end
      end

      def get_promo_start_date(end_date = nil)
        return '' unless end_date
        date = convert_date(end_date) - 6.days
        date.strftime("%m/%d/%Y")
      end

      def convert_date(input)
        Date.strptime(input, '%m/%d/%y')
      end

      def format_date_year(input = nil)
        return '' unless input
        Date.strptime(input, '%m/%d/%y').strftime('%m/%d/%Y')
      end

      def deduction_type_mapping(mcb_rate, deduction_description)
        sanitized_description = deduction_description.downcase.gsub(/\s+/, '')
        mcb_rate_float = (mcb_rate.to_f) / 100
        if sanitized_description.include?('openingorder')
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

      def sanitize_chain(chain, full_name)
        (!chain || chain.empty?) ? full_name : chain
      end
    end
  end
end
