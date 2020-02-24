module Parsers
  class KehePassThroughPromotion < Base
    class << self
      def invoice_data(document)
        parsed_meta_data(document).deep_merge(parsed_invoice_date(document)
        ).deep_merge(parsed_totals(document)
        ).deep_merge(parsed_customer_and_type(document))
      end

      def parsed_invoice_number(meta_data)
        row_regex = /invoice.*#/i
        str_regex = /invoice.*#/i
        sanitize_invoice_num(meta_data, row_regex, str_regex)
      end

      def alt_invoice_number(meta_data, invoice_row)
        idx = meta_data.index(invoice_row)
        idx ? meta_data[idx].split(/(\s|\:)/).last : nil
      end

      def parsed_customer_and_type(document)
        customer_data = get_customer_data(document)
        customer_str_method_one(customer_data)
      end

      def customer_str_method_one(data)
        regex = /kehe.*distributors?(,?\s*llc)?/i
        distributor_row = string_match_from_arr(data, regex)
        customer_str = distributor_row.to_s.try(:gsub,regex,'').strip
        get_customer_and_type(customer_str)
      end

      def get_customer_and_type(string)
        if !string || string.empty?
          type = ''
          customer = ''
        else
          type = string.to_s.split(/\s/).last
          customer = string.to_s.try(:gsub,type, '').strip
        end

        {'customer' => customer,
         'type' => type}
      end

      def parsed_meta_data(document)
        meta_data = get_meta_data(document)
        invoice_number = invoice_num_from_file_name(document) || parsed_invoice_number(meta_data)

        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_date(document)
        meta_data = get_meta_data(document)
        regex_row = /\d{1,2}\/\d{1,2}\/\d{2,4}.*\d{1,2}\/\d{1,2}\/\d{2,4}/
        regex_str = /\d{1,2}\/\d{1,2}\/\d{2,4}/
        date_row = string_match_from_arr(meta_data, regex_row)
        date_range = date_row.to_s.scan(regex_str)

        if date_range.empty?
          alt_range = string_match_from_arr(meta_data, regex_str).to_s.scan(regex_str).try(:first)
          date_range = [alt_range, alt_range]
        end

        {'invoice_date_range' => date_range}
      end

      def parsed_invoice_details(document)
        data = document['invoice_details']
        {'invoice_details' => data}
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
