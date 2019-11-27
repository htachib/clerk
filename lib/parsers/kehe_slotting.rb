module Parsers
  class KeheSlotting < Base
    class << self
      def parse_rows(document)
        invoice_data(document).deep_merge(
        'file_name' => document['file_name']
        ).deep_merge(
        'uploaded_at' => document['uploaded_at']
        )
      end

      def invoice_data(document)
        parsed_meta_data_cover(document).deep_merge(
          parsed_invoice_date(document)
        ).deep_merge(parsed_invoice_details(document))
      end

      def get_raw_data(document, type)
        document[type].map {|row| row.values }
      end

      def parsed_meta_data_cover(document)
        parsed = {}
        data = get_raw_data(document,'meta_data_cover').map { |row| row.join(' ') }

        parsed['invoice number'] = data[0].try(:split, '#').try(:last).strip
        parsed['PO #'] = data[2].try(:split,'#').try(:last).strip
        parsed['DC #'] = data[3].try(:gsub,'|','').try(:split,'#').try(:last).strip
        parsed['Type'] = data[4].try(:split,' ').try(:last).strip
        parsed
      end

      def parse_cell(data, regex)
        data.select { |cell| cell.match?(regex) }.try(:first)
      end

      def parsed_invoice_details(document)
        parsed = {}
        data = get_raw_data(document,'invoice_details').flatten
        parsed['chain'] = parse_cell(data, /chain/i).try(:split,':').try(:last).try(:strip).try(:gsub,/\W/,'')
        slotting_fee = parse_cell(data, /slotting.*cost/i).try(:split,'$').try(:last).try(:strip)
        ep_fee = parse_cell(data, /ep.*fee/i).try(:split,'$').try(:last)
        parsed['chargeback_amount'] = string_to_float(slotting_fee) + string_to_float(ep_fee)
        parsed['ep_fee'] = ep_fee
        parsed
      end

      def string_to_float(input)
        input.try(:gsub,',','').to_f
      end

      def parsed_invoice_date(document)
        invoice_date_one = document['meta_data'].try(:first).try(:[], 'invoice_date')
        invoice_date_two = get_raw_data(document, 'invoice_date').try(:flatten).try(:first)
        invoice_date =  invoice_date_one.try(:gsub,/([^0-9\/])/,'') || invoice_date_two
        {'invoice_date' => invoice_date}
      end
    end
  end
end
