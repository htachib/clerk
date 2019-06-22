module Parsers
  class KeheMerchandisingInvoice < Base
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
        ).deep_merge(parsed_totals(document)
        ).deep_merge(parsed_customer(document))
      end

      def get_raw_data(document, type)
        document[type].map { |row| row.values }
      end

      def invoice_num(meta_data)
        invoice_num_rows = meta_data.select{|row| row.match(/invoice.*#/i) }
        invoice_num = invoice_num_rows.first.gsub(/invoice.*#/i,'').strip
        invoice_num.empty? ? alt_invoice_num(meta_data, invoice_num_rows.last) : invoice_num
      end

      def alt_invoice_num(meta_data, invoice_row)
        idx = meta_data.index(invoice_row) + 1
        meta_data[idx].split(' ').last
      end

      def customer_string(rows)
        regex = /(chargeback.*\/.*invoice)/i
        regex_two = /^\s*charges\s*/i
        regex_three = /\d+/
        regex_four = /^\s*date/i

        rows.select do |row|
          !row.match(regex) && !row.match(regex_two) &&
          !row.match(regex_three) && !row.match(regex_four)
        end.first
      end

      def sanitized_customer(rows)
        customer_str = customer_string(rows)
        customer_str.gsub(/(invoice\s*#?|charge|date|program|merchandising)/i,'').strip
      end

      def parsed_customer(document)
        rows = get_raw_data(document, 'customer').flatten
        customer = sanitized_customer(rows)
        {'detailed_customer' => customer}
      end

      def parsed_meta_data(document)
        parsed = {}
        meta_data = get_raw_data(document,'meta_data').map do |row|
          row.join(' ')
        end

        parsed['invoice number'] = invoice_num(meta_data)
        type_row = meta_data.select{|row| row.match(/type.*:?/i) }.first
        parsed['Type'] = type_row.gsub(/type\W?/i,'')
        parsed
      end

      def parsed_invoice_date(document)
        date = get_raw_data(document, 'invoice_dates').flatten[0]
        {'invoice_date' => date}
      end

      def parsed_totals(document)
        totals = get_raw_data(document, 'totals').flatten

        ep_fee = totals.select{|row| row.match(/ep.*fee/i) }.first
        ep_fee_str = get_amount_str(ep_fee)
        ep_fee_in_dollars = str_to_dollars(ep_fee_str)

        total = totals.select{|row| row.match(/invoice.*total/i) }.first
        total_str = get_amount_str(total)
        total_in_dollars = str_to_dollars(total_str)

        {'chargeback_amount' => total_in_dollars,
          'ep_fee' => ep_fee_in_dollars}
      end
    end
  end
end
