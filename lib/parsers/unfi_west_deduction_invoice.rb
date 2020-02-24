module Parsers
  class UnfiWestDeductionInvoice < Base
    class << self
      PARSER_RULE_OPTIONS = [
        { 'file_name_regex' => /\d{2}\d{2}URMMCB.*CASA/, 'date_regex' => /(....)URMMCB.*CASA/,'invoice_number_option' => 'invoice_number_2', 'invoice_date_option' => nil, 'chargeback_option' => 'total_mcb', 'division' => nil, 'upc' => nil, 'item_description' => nil, 'ep_fee' => nil, 'shipped' => nil },
        { 'file_name_regex' => /\d{2}\d{2}URMP.*CASA/, 'date_regex' => /(....)URMP.*CASA/,'invoice_number_option' => 'invoice_number_2', 'invoice_date_option' => nil, 'chargeback_option' => 'total_deduction', 'division' => nil, 'upc' => nil, 'item_description' => nil, 'ep_fee' => 'processing_fee', 'shipped' => nil },
        { 'file_name_regex' => /HARMNIP\d{2}\d{4}/, 'date_regex' => /HARMNIP(......)/,'invoice_number_option' => 'invoice_number_2', 'invoice_date_option' => nil, 'chargeback_option' => 'total', 'division' => nil, 'upc' => nil, 'item_description' => nil, 'ep_fee' => nil, 'shipped' => nil },
        { 'file_name_regex' => /KG.*.*CASA/, 'date_regex' => /KG.*.*CASA/,'invoice_number_option' => 'invoice_number_2', 'invoice_date_option' => 'week_ending_date', 'chargeback_option' => 'accrued_amount', 'division' => 'division', 'upc' => 'upc', 'item_description' => 'item_description', 'ep_fee' => nil, 'shipped' => 'shipped' }, #extra total and admin fee row
        { 'file_name_regex' => /URMTO.*HCM/, 'date_regex' => /URMTO.*HCM/,'invoice_number_option' => 'invoice_number_3', 'invoice_date_option' => 'invoice_date', 'chargeback_option' => 'total', 'division' => nil, 'upc' => nil, 'item_description' => nil, 'ep_fee' => nil, 'shipped' => nil },
        { 'file_name_regex' => /WRDC\d{2}\d{2}.*/, 'date_regex' => /WRDC(....).*/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'sum_total', 'division' => nil, 'upc' => nil, 'item_description' => nil, 'ep_fee' => nil, 'shipped' => nil },
        { 'file_name_regex' => /WROSF\d{2}\d{2}.*/, 'date_regex' => /WROSF(....).*/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'sum_total', 'division' => nil, 'upc' => nil, 'item_description' => nil, 'ep_fee' => nil, 'shipped' => nil },
        { 'file_name_regex' => /WRCRDMCB.*/, 'date_regex' => /WRCRDMCB.*/,'invoice_number_option' => 'invoice_number_3', 'invoice_date_option' => 'invoice_date', 'chargeback_option' => 'total', 'division' => nil, 'upc' => nil, 'item_description' => nil, 'ep_fee' => nil, 'shipped' => nil },
        { 'file_name_regex' => /KGFRSR\d{2}\d{2}.*/, 'date_regex' => /KGFRSR(....).*/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => 'invoice_date', 'chargeback_option' => 'total', 'division' => nil, 'upc' => nil, 'item_description' => nil, 'ep_fee' => nil, 'shipped' => nil }, # no sample documents yet
        { 'file_name_regex' => /WFM\w{3}\d{2}.*ISEGR/, 'date_regex' => /WFM\w{3}(..).*ISEGR/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => 'invoice_date', 'chargeback_option' => 'total', 'division' => nil, 'upc' => nil, 'item_description' => nil, 'ep_fee' => nil, 'shipped' => nil }, # no sample documents yet
        { 'file_name_regex' => /WRNACVTN\d{2}\d{2}.*/, 'date_regex' => /WRNACVTN(....).*/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'sum_total', 'division' => nil, 'upc' => nil, 'item_description' => nil, 'ep_fee' => nil, 'shipped' => nil }
      ]

      MULTILINE_PARSERS = [
        { 'file_name_regex' => /KG.*.*CASA/,'chargeback_amount' => 'admin_fee', 'ep_fee' => 'admin_fee', 'division' => nil, 'upc' => nil, 'item_description' => nil, 'shipped' => nil }
      ]

      def parse_rows(document)
        rows = []

        if multiline_parser?(document)
          rows = multi_rows(document)
        else
          rows.push(invoice_data(document))
        end

        rows
      end

      def multi_rows(document)
        row_data = []
        row_count = document.try(:[], 'upc').try(:count)

        row_count.times do |row_idx|
          row_data.push(invoice_data(document, row_idx))
        end

        add_row = total_row(document)
        row_data.push(add_row)
        row_data
      end

      def multiline_parser?(document)
        rule = multiline_parser_rule(document)
        !!rule
      end

      def multiline_parser_rule(document)
        MULTILINE_PARSERS.each do |rule|
          file_name = file_name(document)
          return rule if file_name.try(:match?, rule['file_name_regex'])
        end
        nil
      end

      def total_row(document)
        add_row = invoice_data(document, 0)
        rule = multiline_parser_rule(document)

        rule.keys.each do |k|
          next if k == 'file_name_regex'
          if !rule[k]
            add_row[k] = nil
          elsif rule[k] == 'admin_fee'
            add_row[k] = parsed_admin_fee(document)
          else
            add_row[k] = parsed_data(document, rule[k])
          end
        end
        add_row
      end

      def invoice_data(document, idx = nil)
        parsed_invoice_date(document).deep_merge(
        parsed_invoice_number(document)).deep_merge(
        parsed_chargeback(document, idx)).deep_merge(
        parsed_ep_fee(document)).deep_merge(
        parsed_division(document)).deep_merge(
        parsed_upc(document, idx)).deep_merge(
        parsed_item_description(document, idx)).deep_merge(
        parsed_shipped(document, idx)).deep_merge(
        meta_data(document))
      end

      def meta_data(document)
        { 'uploaded_at' => document['uploaded_at'],
          'file_name' => document['file_name'] }
      end

      def file_name(document)
        document.try(:[], 'file_name')
      end

      def parser_rule_match(file_name)
        PARSER_RULE_OPTIONS.each do |rule|
          return rule if file_name.try(:match?, rule['file_name_regex'])
        end
        nil
      end

      def parser_rule_option(document, option_name)
        file_name = file_name(document)
        rule = parser_rule_match(file_name)
        rule[option_name]
      end

      def parsed_rule(document, option_name)
        option = parser_rule_option(document, option_name)
        return nil if option.nil?
        parsed_data(document, option)
      end

      def parser_date_regex(document)
        file_name = file_name(document)
        rule = parser_rule_match(file_name)
        rule['date_regex']
      end

      def parsed_invoice_date(document)
        invoice_date_option = parser_rule_option(document, 'invoice_date_option')
        invoice_number = parsed_invoice_number(document).try(:[], 'invoice_number')

        if invoice_date_option.nil?
          date_regex = parser_date_regex(document)
          date_string = invoice_number.try(:scan, date_regex).try(:flatten).try(:first)
          date_string_to_promo_dates(date_string)
        elsif invoice_date_option == 'week_ending_date'
          week_ending_date_str = parsed_data(document, 'week_ending_date')
          week_ending_date = Date.strptime(week_ending_date_str,'%m/%d/%Y')
          { 'start_date' => week_ending_date - 6.days,
            'end_date' => week_ending_date }
        else
          { 'start_date' => parsed_data(document, invoice_date_option),
            'end_date' => parsed_data(document, invoice_date_option) }
        end
      end

      def parsed_invoice_number(document)
        invoice_number = parsed_rule(document, 'invoice_number_option')
        match_from_file_name = match_to_file_name(invoice_number, document['file_name'], 5)
        {'invoice_number' => match_from_file_name}
      end

      def multiline_parsed_option(document, idx, option_name)
        option = parser_rule_option(document, option_name)
        document.try(:[], option).try(:[], idx).try(:values).try(:first)
      end

      def parsed_chargeback(document, idx)
        total = !!idx ? multiline_parsed_option(document, idx, 'chargeback_option') : parsed_rule(document, 'chargeback_option')
        {'chargeback_amount' => total}
      end

      def parsed_ep_fee(document)
        ep_fee = parsed_rule(document, 'ep_fee')
        {'ep_fee' => ep_fee}
      end

      def parsed_division(document)
        division = parsed_rule(document, 'division')
        {'division' => division}
      end

      def parsed_upc(document, idx)
        upc = !!idx ? multiline_parsed_option(document, idx, 'upc') : parsed_rule(document, 'upc')
        {'upc' => upc}
      end

      def parsed_item_description(document, idx)
        item_description = !!idx ? multiline_parsed_option(document, idx, 'item_description') : parsed_rule(document, 'item_description')
        {'item_description' => item_description}
      end

      def parsed_shipped(document, idx)
        shipped = !!idx ? multiline_parsed_option(document, idx, 'shipped') : parsed_rule(document, 'shipped')
        {'shipped' => shipped}
      end

      def parsed_admin_fee(document)
        admin_fee_group_str = document.try(:[], 'admin_fee').try(:map, &:values).try(:flatten)
        admin_fee_group = admin_fee_group_str.map do |str|
          str.try(:gsub, 'O', '0')
          str.to_dollars
        end

        admin_fee_group.try(:min)
      end
    end
  end
end
