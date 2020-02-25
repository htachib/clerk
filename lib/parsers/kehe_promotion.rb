module Parsers
  class KehePromotion < Base
    class << self
      def invoice_data(document)
        parsed_meta_data_cover(document).deep_merge(
          parsed_invoice_details(document)
        ).deep_merge(parsed_invoice_date(document))
      end

      def parsed_meta_data_cover(document)
        parsed = {}
        data = get_raw_data(document,'meta_data_cover').map { |row| row.join(' ') }

        parsed['invoice_number'] = data[0].try(:split,'#').try(:last).strip
        parsed['po_num'] = data[2].try(:split,'#').try(:last).strip
        parsed['dc_num'] = data[3].try(:split,'#').try(:last).strip
        parsed['type'] = data[4].try(:split,' ').try(:last).strip
        parsed
      end

      def parse_cell(data, regex)
        data.select { |cell| cell.match?(regex) }.try(:first)
      end

      def parsed_invoice_details(document)
        parsed = {}
        data = get_raw_data(document,'invoice_details').flatten
        parsed['broker_id'] = parse_cell(data, /broker/i).scan(/\d+/)[0]
        parsed['chain'] = parse_cell(data, /chain/i).try(:split,' ').try(:last)
        parsed['chargeback_amount'] = parse_cell(data, /invoice.*total/i).try(:split,'$').try(:last)
        parsed['ep_fee'] = parse_cell(data, /ep.*fee/i).try(:split,'$').try(:last)
        parsed
      end

      def parsed_invoice_date(document)
        invoice_date = document['invoice_date'].try(:first).try(:values).try(:first)
        {'invoice_date' => invoice_date}
      end
    end
  end
end
