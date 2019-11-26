module Mappers
  class UNFIEastChargeback < Base
    class << self

      def prepare_rows(raw_rows)
        raw_rows.map do |raw_row|
          prepared_row = OutputHeaders::ROW_FIELDS.deep_dup
          prepared_row['Customer'] = 'UNFI East'
          prepared_row['Parser'] = 'UNFI East Chargeback'
          prepared_row['File Name'] = raw_row['file_name'].try(:gsub, '.pdf','')
          prepared_row['Invoice Number'] = raw_row['vendor_invoice']
          prepared_row['Deduction Post Date'] = Date.parse(raw_row['uploaded_at']).strftime("%m/%d/%Y")
          prepared_row['Promo Start Date'] = format_date(raw_row['chargeback_date'])
          prepared_row['Promo End Date'] = format_date(raw_row['chargeback_date'])
          deduction_type = get_deduction_type(raw_row['deduction_type'])
          prepared_row['Deduction Type'] = deduction_type
          purchase_order = get_deduction_type(raw_row['purchase_order'])
          prepared_row['Deduction Description'] = get_deduction_description(deduction_type, purchase_order)
          prepared_row['Customer Chain ID'] = 'UNFI East'
          prepared_row['Customer Detailed Name'] = 'UNFI East'
          prepared_row['Chargeback Amount'] = get_chargeback_amount(raw_row['chargeback_amount'])
          prepared_row['Customer Number'] = ''
          prepared_row['Customer Location'] = ''
          prepared_row['Customer City'] = ''
          prepared_row['Customer State'] = ''
          prepared_row['Variable Rate Per Unit'] = set_variable_rate(prepared_row)

          prepared_row.values # => [['asdf', 'asdf', 'asdf']]
        end
      end

      def get_deduction_type(input)
        input.split(' ').last
      end

      def get_deduction_description(type, po)
        if (type.downcase == 'pricing')
          "Price Discrepancy - PO #{po}"
        elsif (type.downcase == 'quantity')
          "Over/Short Ship - PO #{po}"
        else
          "Unrecognized - PO #{po}"
        end
      end

      def get_chargeback_amount(input)
        input.try(:gsub,'-','').to_f
      end

      def format_date(input)
        Date.strptime(input, "%m/%d/%y").strftime("%m/%d/%Y")
      end
    end
  end
end
