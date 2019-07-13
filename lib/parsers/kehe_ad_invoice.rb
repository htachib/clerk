module Parsers
  class KeheAdInvoice < Base
    class << self
      include Parsers::Helpers::KeheSanitizers

      def invoice_data(document)
        parsed_meta_data(document).deep_merge(
        parsed_invoice_date(document)).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_deduction_description(document)).deep_merge(
        parsed_customer_chain(document)).deep_merge(
        parsed_promo_date_range(document))
      end

      def parsed_invoice_number(meta_data)
        row_regex = /invoice.*#/i
        str_regex = /invoice.*#/i
        sanitize_invoice_num(meta_data, row_regex, str_regex)
      end

      def parsed_type(meta_data)
        regex = /type.*:?/i
        type_row = string_match_from_arr(meta_data, regex)
        type_row.to_s.gsub(/type:?/i,'').strip
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

      def parsed_deduction_description(document)
        data = get_raw_data(document,'deduction_description').flatten
        filtered = data.select { |row| row.length > 5 }
        deduction_description = filtered.join(' ').gsub(/[^\s^\w^\/]/,'')
        {'deduction_description' => deduction_description}
      end

      def parsed_customer_chain(document)
        options = ['customer_name_option_1', 'customer_name_option_2', 'customer_name_option_3']
        customer_chain_data = options.map { |option| get_raw_data(document, option) }.flatten
        customer_chain = customer_chain_data.select { |c| c.length > 3 }.first.try(:titleize) || 'KeHE'
        {'customer_chain' => customer_chain}
      end

      def parsed_promo_date_range(document)
        options = ['date_range_option_1', 'date_range_option_2', 'date_range_option_3',
                   'date_range_option_4']
        promo_dates_data = options.map { |option| get_raw_data(document, option) }.flatten
        promo_dates = promo_dates_data.select { |c| c.length > 3 }.first.strip
        {'promo_dates' => get_promo_dates(promo_dates)}
      end

      def date_promo_month(year_int, month_int, date_int)
        DateTime.new(year_int, month_int, date_int).strftime("%m/%d/%y")
      end

      def get_promo_dates(string)
        if string.match?(/[a-z]{3,}/i)
          month_string = string.match(/[a-z]+/i).try(:[], 0)
          month_int = month_int_from_string(month_string)
          year_int = string.scan(/[0-9]+/i).first.to_i
          start_date = date_promo_month(year_int, month_int, 1)
          end_date = date_promo_month(year_int, month_int, -1)
        elsif string.scan(/\//i).count == 4
          start_date, end_date = string.try(:scan, /\d{1,2}\/\d{1,2}\/\d{2,4}/)
        end
        {'start_date' => start_date,
         'end_date' => end_date}
      end
    end
  end
end
