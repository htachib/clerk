module Parsers
  class UNFIEastDeductionQuarterly < Base
    DEDUCTION_TYPES = ['Scan', 'Ad Fee', 'Sales Report', 'Slotting', 'Trade Shows',
                       'Free Fill', 'Merchandising', 'Ads', 'PTY']

    class << self
      def parse_rows(document)
        row = deduction_num(document).deep_merge(
          'file_name' => document['file_name']
        ).deep_merge(
          'uploaded_at' => document['uploaded_at']
        ).deep_merge(
          parsed_amount(document)
        ).deep_merge(
          parsed_invoice_summary(document)
        )

        [row]
      end

      def meta_data(document)
        document['meta_data']
      end

      def deduction_num(document)
        number = meta_data(document).try(:[], 0).try(:values).try(:first).try(:split, ' ').try(:last)
        {'deduction_num' => number }
      end

      def invoice_collection?(data)
        header = data.try(:[], 0).try(:values).try(:join, '')
        header.try(:downcase).try(:include?, 'customer')
      end

      def parsed_invoice_summary(document)
        binding.pry
        data_option_one = document.try(:[], 'invoice_summary_option_1')
        data_option_two = document.try(:[], 'invoice_summary_option_2')
        data_option_three = document.try(:[], 'invoice_summary_option_3')
        data_option_four = document.try(:[], 'invoice_summary_option_4').try(:first)
        data_str = data_option_three.map{|r| r.try(:values)}.try(:flatten).try(:join, '')
        if data_option_one.nil? && data_str.try(:downcase).try(:include?, 'annual') && data_str.try(:downcase).try(:include?, 'annual')
          parse_eagle(data_option_four)
        elsif data_option_three.try(:count) > 2 && invoice_collection?(data_option_three)
          parse_collection_invoice(data_option_three).deep_merge(parsed_invoice_date(document))
        elsif data_option_three.try(:count) > 2
          parse_collection_invoice_no_header(data_str)
        else
          parse_single_invoice(data_option_one).deep_merge(parsed_invoice_date(document))
        end
      end

      def parse_collection_invoice_no_header(data_str)

        chargeback_amount = data_str.try(:scan, /\${1}\d*\,?\d+\.?\d*/).try(:last)
        {
          'chargeback_amount' => chargeback_amount,
          
        }
      end

      def parsed_invoice_date(document)
        meta_section = document['meta_data'].map{ |row| row.try(:values) }.try(:flatten).try(:join, '')
        start_date, end_date = meta_section.try(:scan, /\d{1,2}\/\d{1,2}\/\d{2,4}/).try(:first)
        {'start_date' => start_date,
          'end_date' => end_date}
      end

      def parse_single_invoice(data)
        rows = data.try(:last)
        admin_fee_str = rows.try(:[], 'key_6')
        admin_fee = str_to_dollars(admin_fee_str) if defined?(admin_fee_str)
        billing_desc = rows.try(:[], 'key_2')
        shipped_str = rows.try(:[], 'key_5')
        shipped = str_to_dollars(shipped_str) if defined?(shipped_str)

        deduction_detail = parsed_deduction_detail(billing_desc)
        deduction_type = deduction_detail.try(:[], 'deduction_type')
        customer = deduction_detail.try(:[], 'customer')

        {
          'billing_desc' => billing_desc,
          'deduction_type' => soft_fail(deduction_type),
          'customer' =>  soft_fail(customer),
          'admin_fee' => soft_fail(admin_fee),
          'shipped' => soft_fail(shipped)
        }
      end

      def parse_eagle(data)
        chargeback_str = data.try(:[], 'total')
        chargeback_amount = get_amount_str(chargeback_str)
        billing_desc = data.try(:[], 'billing_desc')
        year = billing_desc.scan(/\d{4}/).try(:first).try(:to_i)
        month_start_str, month_end_str = billing_desc.try(:split, '-')
        month_start = month_int_from_string(month_start_str)
        month_end = month_int_from_string(month_end_str)
        start_date = Date.new(year, month_start, 1)
        end_date = Date.new(year, month_end, 1).end_of_month

        {
          'billing_desc' => "#{billing_desc} Agreements",
          'deduction_type' => 'Ad Fee',
          'customer' =>  'UNFI East',
          'chargeback_amount' => chargeback_amount,
          'start_date' => start_date,
          'end_date' => end_date
        }
      end

      def parse_collection_invoice(data)
        first_row = data.try(:[], 3).try(:values)
        customer = first_row.try(:[], 1)
        return { 'customer' => customer }
      end

      def parsed_deduction_detail(input)
        result = {}

        DEDUCTION_TYPES.each do |type|
          sanitized_type = type.try(:downcase).try(:gsub, /\s+/, '')
          sanitized_input = input.try(:downcase).try(:gsub, /\s+/, '')
          if sanitized_input.try(:include?, sanitized_type)
            result['deduction_type'] = exception_types(type)
            result['customer'] = sanitized_input.try(:split, sanitized_type).try(:first).upcase
          end
        end

        result
      end

      def exception_types(type)
        if type == 'Ads'
          return 'Ad Fee'
        else
          return type
        end
      end

      def parsed_amount(document)
        amount = document.try(:[], 'amount').try(:first).try(:values).try(:first)
        {'amount' => amount}
      end
    end
  end
end
