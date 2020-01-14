module Parsers
  class UnfiEastDeductionQuarterly < Base
    DEDUCTION_TYPES = ['Scan', 'Ad Fee', 'Sales Report', 'Slotting', 'Trade Shows',
                       'Free Fill', 'Merchandising', 'Ads', 'PTY']

    class << self
      def parse_rows(document)
        row = deduction_num(document).deep_merge(
          'file_name' => document['file_name']
        ).deep_merge(
          'uploaded_at' => document['uploaded_at']
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

      def first_row(document, rule)
        data = document.try(:[], rule)
        data.try(:first)
      end

      def parsed_invoice_summary(document)
        # assign document to specific set of parser rules depending on column header
        headers = document.try(:[], 'headers').try(:first).try(:values).try(:first)
        if headers.try(:match?, /po\#\/reference/i) # eagle - option 4
          parser_four(document)
        elsif headers.try(:match?, /dbs\s*sj\#/i) # 51304CASA - 00488823WEGMNS
          parser_five(document)
        elsif headers.try(:match?, /(billing.*description.*upc.*perform)/i) # FSRGEFEB
          parser_one(document)
        elsif headers.try(:match?, /mcb.*type.*chain.*whole.*billback/i) # 51304CASA - URMTO177106121HCM
          parser_three(document)
        else
          {}
        end
      end

      def meta_amount(document)
        chargeback_str = document.try(:[], 'amount').try(:first).try(:values).try(:first)
        str_to_dollars(chargeback_str)
      end

      def parser_three(document)
        row = first_row(document, 'invoice_summary_option_3')
        mcb_type = row.try(:[], 'mcb_type')
        customer = row.try(:[], 'customer_name')
        chain = row.try(:[], 'quantity')

        meta_data = get_meta_data(document)
        meta_data_str = meta_data.try(:join, ' ')
        date_str = string_to_date(meta_data_str).try(:first) if defined?(meta_data_str)
        month_int = month_int_from_string(mcb_type)
        date = Date.strptime(date_str, '%m/%d/%Y')
        year_int = date.try(:year)
        start_date = date_formatted_promo(year_int, month_int, 1) || nil
        end_date = date_formatted_promo(year_int, month_int, -1) || nil
        chargeback_amount = meta_amount(document)

        {
          'billing_desc' => mcb_type,
          'deduction_type' => 'MCB',
          'customer' =>  customer,
          'chain' => chain,
          'chargeback_amount' => chargeback_amount,
          'start_date' => start_date,
          'end_date' => end_date
        }
      end

      def parser_one(document)
        row = first_row(document, 'invoice_summary_option_1')
        meta_data = get_meta_data(document)

        meta_data_str = meta_data.try(:join, ' ')
        perform_dates = row.try(:[], 'perform_dates')
        month_int = month_int_from_string(perform_dates)
        year_int = perform_dates.try(:scan,/\d{2,4}/).try(:first).try(:to_i)

        start_date = date_formatted_promo(year_int, month_int, 1) || nil
        end_date = date_formatted_promo(year_int, month_int, -1) || nil

        customer = row.try(:[], 'customer_name')
        chargeback_amount = meta_amount(document)

        {
          'billing_desc' => 'TBD',
          'deduction_type' => 'TBD',
          'customer' =>  customer,
          'chargeback_amount' => chargeback_amount,
          'start_date' => start_date,
          'end_date' => end_date
        }
      end

      def get_meta_data(document)
        document.try(:[], 'meta_data').map{ |d| d.try(:values) }.try(:flatten)
      end

      def parser_five(document)
        row = first_row(document, 'invoice_summary_option_5')
        chargeback_str = row.try(:[], 'total')
        chargeback_amount = str_to_dollars(chargeback_str)

        shipped_str = row.try(:[], 'amount')
        shipped = str_to_dollars(shipped_str)

        billing_desc = row.try(:[], 'billing_description')
        meta_data = get_meta_data(document)
        meta_data_str = meta_data.try(:join, ' ')
        date = string_to_date(meta_data_str).try(:first) if defined?(meta_data_str)
        start_date = end_date = date

        admin_fee_str = row.try(:[], 'admin_fee')
        admin_fee = str_to_dollars(admin_fee_str) if defined?(admin_fee_str)

        deduction_detail = parsed_deduction_detail(billing_desc)
        deduction_type = deduction_detail.try(:[], 'deduction_type')
        customer = deduction_detail.try(:[], 'customer')

        {
          'billing_desc' => billing_desc,
          'deduction_type' => deduction_type,
          'customer' =>  customer,
          'admin_fee' => admin_fee,
          'shipped' => shipped,
          'chargeback_amount' => chargeback_amount,
          'start_date' => start_date,
          'end_date' => end_date
        }
      end

      def month_strings(description)

      end

      def parser_four(document)
        row = first_row(document, 'invoice_summary_option_4')
        chargeback_str = row.try(:[], 'total')
        chargeback_amount = str_to_dollars(chargeback_str)
        billing_desc = row.try(:[], 'billing_desc')
        year = billing_desc.scan(/\d{4}/).try(:first).try(:to_i)
        month_count = month_count_from_string(billing_desc)
        if month_count == 2
          month_start_str, month_end_str = billing_desc.try(:split, '-')
        elsif month_count == 1
          month_start_str = month_end_str = billing_desc
        else
          month_start_str = month_end_str = nil
        end

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
    end
  end
end
