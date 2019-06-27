module Parsers
  class KeheLateDeliveryFee < Base
    class << self
      include Parsers::Helpers::KeheSanitizers

      def invoice_data(document)
        parsed_meta_data(document).deep_merge(parsed_invoice_date(document)
        ).deep_merge(parsed_address(document)
        ).deep_merge(parsed_broker_details(document)
        ).deep_merge(parsed_totals(document))
      end

      def parsed_meta_data(document)
        parsed = {}
        meta_data = get_meta_data(document)
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
        broker_id = broker_details.scan(/broker\s+#\s*.\s*\d+/i)[0].to_s.scan(/\d+/)[0]
        department_id = broker_details.scan(/DEPT\s+#\s*.\s*\d+/i)[0].to_s.scan(/\d+/)[0]
        {'broker_id' => broker_id, 'department_id' => department_id}
      end

      def parsed_totals(document)
        totals = get_totals(document)
        chargeback_amount = parsed_chargeback(totals)
        ep_fee_amount = parsed_ep_fee(totals)

        {'chargeback_amount' => chargeback_amount,
          'ep_fee' => ep_fee_amount}
      end

      def parsed_chargeback(totals)
        invoice_total_row = totals ? totals.select{ |row| row.match(/$/)}.last : nil
        invoice_total = get_amount_str(invoice_total_row)
        str_to_dollars(invoice_total)
      end

      def parsed_ep_fee(totals)
        ep_fee_regex = /ep.*fee/i
        get_total_in_dollars(totals, ep_fee_regex)
      end
    end
  end
end
