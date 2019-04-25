module Parsers
  class KehePassThroughPromotion
    class << self
      def parse_rows(document)
        invoice_data(document).deep_merge(
        'file_name' => document['file_name']
        ).deep_merge(
        'uploaded_at' => document['uploaded_at']
        )
      end

      def invoice_data(document)
        parsed_meta_data_cover(document).deep_merge(parsed_meta_data(document)
        ).deep_merge(parsed_invoice_details(document)
        ).deep_merge(parsed_totals(document)
        ).deep_merge(parsed_customer_data(document))
      end

      def get_raw_data(document, type)
        document[type].map {|row| row.values }
      end

      def parsed_customer_data(document)
        parsed = {}
        data = get_raw_data(document,'customer_data').map { |row| row.join(' ') }
        parsed['customer_name'] = data[0].split(' ').first.strip
        parsed['invoice_type'] = data[0].split(' ').last.strip
        parsed
      end

      def parsed_meta_data_cover(document)
        parsed = {}
        data = get_raw_data(document,'meta_data_cover').map { |row| row.join(' ') }

        parsed['invoice number'] = data[0].split('#').last.strip
        parsed['PO #'] = data[2].split('#').last.strip
        parsed['DC #'] = data[3].split(':').last.strip
        parsed['Type'] = data[4].split(':').last.strip
        parsed
      end

      def parsed_meta_data(document)
        parsed = {}
        data = get_raw_data(document,'meta_data').flatten
        parsed['division'] = parse_cell(data, /division/i).scan(/\d+/)[0]
        parsed['invoice date'] = parse_cell(data, /invoice\s*date/i).scan(/\d+\/\d+\/\d+/)[0]
        parsed['broker_id'] = parse_cell(data, /broker/i).scan(/\d+/)[0]
        parsed
      end

      def parse_cell(data, regex)
        data.select { |cell| cell.match?(regex) }.first
      end

      def parsed_invoice_details(document)
        data = document['invoice_details']
        {'invoice_details' => data}
      end

      def parsed_totals(document)
        data = document['totals'].map { |row| row.values.join(' ') }
        total_chargeback_amount = data.last.split('$').last
        ep_fee = data[-2].split('$').last
        {'chargeback_amount' => total_chargeback_amount,
          'ep_fee' => ep_fee}
      end
    end
  end
end
