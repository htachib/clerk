module Parsers
  class KeheScanInvoice < Base
    class << self
      include Parsers::Helpers::KeheSanitizers

      def invoice_data(document)
        parsed_meta_data(document).deep_merge(parsed_invoice_date(document)
        ).deep_merge(parsed_totals(document)
        ).deep_merge(parsed_customer(document))
      end

      def parsed_invoice_number(meta_data)
        row_regex = /invoice.*#/i
        str_regex = /invoice.*#/i
        sanitize_invoice_num(meta_data, row_regex, str_regex)
      end

      def customer_row_idx(rows)
        row_idx = rows.find_index{|row| row.to_s.match?(/(phone|fax)/i)}
        row_idx ? row_idx + 1 : nil
      end

      def sanitized_customer(rows)
        customer_row = rows.try(:last)
        if customer_row.to_s.match?(/(chargeback.*invoice)/i)
          idx = customer_row_idx(rows)
          row = rows.try(:[], idx)
          customer_row = row.to_s.match?(/chargeback.*invoice/i) ? 'KeHE' : row
        end

        regex = /(date|\#|scans|scan|chargeback|invoice|reclamation|recovery|date.*invoice$)/i
        customer_row.to_s.gsub(regex,'').strip
      end

      def parsed_customer(document)
        rows = get_customer_data(document)
        customer = sanitized_customer(rows)
        {'detailed_customer' => customer}
      end

      def parsed_type(meta_data)
        regex = /type.*:?/i
        type_row = string_match_from_arr(meta_data, regex)
        type_row.to_s.gsub(/type\W?/i,'').strip
      end

      def parsed_meta_data(document)
        meta_data = get_meta_data(document)
        invoice_number = invoice_num_from_file_name(document) || parsed_invoice_number(meta_data)
        type = parsed_type(meta_data)

        {'invoice number' => invoice_number,
          'Type' => type}
      end

      def parsed_invoice_date(document)
        invoice_date_row = get_raw_data(document, 'invoice_date')
        date = get_invoice_date(invoice_date_row, document)
        {'invoice_date' => date}
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
