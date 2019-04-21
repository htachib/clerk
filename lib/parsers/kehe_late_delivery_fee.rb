module Parsers
  class KeheLateDeliveryFee
    class << self
      def parse_rows(document)
        invoice_data(document).deep_merge(
        'file_name' => document['file_name']
        ).deep_merge(
        'uploaded_at' => document['uploaded_at']
        )
      end

      def invoice_data(document)
        parsed_meta_data(document).deep_merge(parsed_invoice_date(document)
        ).deep_merge(parsed_address(document)
        ).deep_merge(parsed_broker_details(document)
        ).deep_merge(parsed_totals(document))
      end

      def get_raw_data(document, type)
        document[type].map {|row| row.values }
      end

      def parsed_meta_data(document)
        parsed = {}
        meta_data = get_raw_data(document,'meta_data').map do |row|
          row.join(' ')
        end

        parsed['invoice number'] = meta_data[0].split('#').last.strip
        parsed['PO #'] = meta_data[2].split('#').last.strip
        parsed['DC #'] = meta_data[3].split(':').last.strip
        parsed['Type'] = meta_data[4].split(':').last.strip
        parsed
      end

      def parsed_invoice_date(document)
        date = get_raw_data(document, 'invoice_date').flatten[0]
        {'invoice_date' => date}
      end

      def parsed_address(document)
        address = get_raw_data(document, 'address').join(' ')
        {'address' => address}
      end

      def parsed_broker_details(document)
        broker_details = get_raw_data(document, 'broker_details').join(' ')
        broker_id = broker_details.scan(/broker\s+#\s*.\s*\d+/i)[0].scan(/\d+/)[0]
        department_id = broker_details.scan(/DEPT\s+#\s*.\s*\d+/i)[0].scan(/\d+/)[0]
        {'broker_id' => broker_id, 'department_id' => department_id}
      end

      def parsed_totals(document)
        totals = get_raw_data(document, 'totals')
        total_chargeback_amount = totals.last.join('').split('$').last
        ep_fee = totals[-2].last.split('$').last
        {'chargeback_amount' => total_chargeback_amount,
          'ep_fee' => ep_fee}
      end
    end
  end
end
