module Parsers
  class KehePromotion < Base
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
          parsed_invoice_details(document)
        ).deep_merge(parsed_invoice_date(document))
      end

      def get_raw_data(document, type)
        document[type].map {|row| row.values }
      end

      def parsed_meta_data_cover(document)
        parsed = {}
        data = get_raw_data(document,'meta_data_cover').map { |row| row.join(' ') }

        parsed['invoice number'] = data[0].split('#').last.strip
        parsed['PO #'] = data[2].split('#').last.strip
        parsed['DC #'] = data[3].split('#').last.strip
        parsed['Type'] = data[4].split(' ').last.strip
        parsed
      end

      def parse_cell(data, regex)
        data.select { |cell| cell.match?(regex) }.first
      end

      def parsed_invoice_details(document)
        parsed = {}
        data = get_raw_data(document,'invoice_details').flatten
        parsed['broker_id'] = parse_cell(data, /broker/i).scan(/\d+/)[0]
        parsed['chain'] = parse_cell(data, /chain/i).split(' ').last
        parsed['chargeback_amount'] = parse_cell(data, /invoice.*total/i).split('$').last
        parsed['ep_fee'] = parse_cell(data, /ep.*fee/i).split('$').last
        parsed
      end

      def parsed_invoice_date(document)
        invoice_date = document['invoice_date'].first.values.first
        {'invoice_date' => invoice_date}
      end
    end
  end
end
