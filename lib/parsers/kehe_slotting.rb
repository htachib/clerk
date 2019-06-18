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

        parsed['invoice number'] = data[0].split('#').last.strip
        parsed['PO #'] = data[2].split('#').last.strip
        parsed['DC #'] = data[3].gsub('|','').split('#').last.strip
        parsed['Type'] = data[4].split(' ').last.strip
        parsed
      end

      def parse_cell(data, regex)
        data.select { |cell| cell.match?(regex) }.first
      end

      def parsed_invoice_details(document)
        parsed = {}
        data = get_raw_data(document,'invoice_details').flatten
        parsed['chain'] = parse_cell(data, /chain/i).split(':').last.strip.gsub(/\W/,'')
        slotting_fee = parse_cell(data, /slotting.*cost/i).split('$').last.strip
        ep_fee = parse_cell(data, /ep.*fee/i).split('$').last
        parsed['chargeback_amount'] = string_to_float(slotting_fee) + string_to_float(ep_fee)
        parsed['ep_fee'] = ep_fee
        parsed
      end

      def string_to_float(input)
        input.gsub(',','').to_f
      end

      def parsed_invoice_date(document)
        invoice_date = document['meta_data'].first['invoice_date']
        {'invoice_date' => invoice_date}
      end
    end
  end
end
