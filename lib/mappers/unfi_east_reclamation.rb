module Mappers
  class UNFIEastReclamation < Base
    class << self

      def prepare_rows(raw_rows)
        raw_rows.map do |raw_row|
          prepared_row = OutputHeaders::ROW_FIELDS.deep_dup
          prepared_row['Customer'] = 'UNFI East'
          prepared_row['Parser'] = 'UNFI East Reclamation'
          prepared_row['File Name'] = raw_row['file_name'].try(:gsub,'.pdf','')
          prepared_row['Invoice Number'] = raw_row['invoice_number']
          uploaded_date = Date.parse(raw_row['uploaded_at']).strftime("%m/%d/%Y")
          prepared_row['Deduction Post Date'] = uploaded_date
          promo_date = raw_row['promo_date']
          promo_end_date = get_promo_end_date(promo_date)
          prepared_row['Promo End Date'] = promo_end_date
          prepared_row['Promo Start Date'] = promo_end_date
          prepared_row['Deduction Type'] = 'Reclamation'
          deduction_description = raw_row['deduction_description']
          prepared_row['Deduction Description'] = deduction_description
          prepared_row['Customer Chain ID'] = get_customer_chain(deduction_description)
          prepared_row['Customer Detailed Name'] = ''
          prepared_row['Chargeback Amount'] = raw_row['grand_total']
          prepared_row['Customer Number'] = ''
          prepared_row['Customer Location'] = ''
          prepared_row['Customer City'] = ''
          prepared_row['Customer State'] = ''
          prepared_row['Variable Rate Per Unit'] = set_variable_rate(prepared_row)

          prepared_row.values # => [['asdf', 'asdf', 'asdf']]
        end
      end

      def get_promo_end_date(input)
        Date.parse(input).end_of_month.strftime("%m/%d/%Y")
      end

      def get_customer_chain(input)
        input.split("Reclamation")[0].strip
      end
    end
  end
end
