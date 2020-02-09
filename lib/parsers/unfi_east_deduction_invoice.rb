module Parsers
  class UnfiEastDeductionInvoice < Base
    class << self
      PARSER_RULE_OPTIONS = [
        { 'file_name_regex' => /.*AHOLD/, 'date_regex' => nil,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => 'invoice_date_2', 'chargeback_option' => 'chargeback_1', 'ep_fee' => 'admin_fee_1', 'deduction_option' => 'deduction_description' },
        { 'file_name_regex' => /.*BIGY/, 'date_regex' => nil,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => 'invoice_date_8', 'chargeback_option' => 'chargeback_1', 'ep_fee' => 'admin_fee_1', 'deduction_option' => 'deduction_description' },
        { 'file_name_regex' => /.*DIBRGS/, 'date_regex' => nil,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => 'invoice_date_3', 'chargeback_option' => 'chargeback_1', 'ep_fee' => 'admin_fee_1', 'deduction_option' => 'deduction_description' },
        { 'file_name_regex' => /.*EOM/, 'date_regex' => nil,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => 'invoice_date_4', 'chargeback_option' => 'chargeback_1', 'ep_fee' => 'admin_fee_1', 'deduction_option' => 'deduction_description' },
        { 'file_name_regex' => /.*EFA/, 'date_regex' => nil,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => 'invoice_date_5', 'chargeback_option' => 'chargeback_1', 'ep_fee' => 'admin_fee_1', 'deduction_option' => 'deduction_description' },
        { 'file_name_regex' => /.*GEAGLE/, 'date_regex' => nil,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => 'invoice_date_6', 'chargeback_option' => 'chargeback_1', 'ep_fee' => 'admin_fee_1', 'deduction_option' => 'deduction_description' },
        { 'file_name_regex' => /FSRGE[a-z]{3}\d{2}.*PB/i, 'date_regex' => /FSRGE(.....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_3', 'ep_fee' => nil, 'deduction_option' => nil },
        { 'file_name_regex' => /FSRGE\d{2}\d{2}.*A/, 'date_regex' => /FSRGE(....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_3', 'ep_fee' => nil, 'deduction_option' => nil },
        { 'file_name_regex' => /FSRGE\d{2}\d{2}.*/, 'date_regex' => /FSRGE(....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_2', 'ep_fee' => 'admin_fee_2', 'deduction_option' => nil },
        { 'file_name_regex' => /FSRGE[a-z]{3}\d{2}.*/i, 'date_regex' => /FSRGE(.....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_3', 'ep_fee' => 'admin_fee_3', 'deduction_option' => nil },
        { 'file_name_regex' => /NSOKOW.*HCM/, 'date_regex' => nil,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => 'invoice_date_8', 'chargeback_option' => 'chargeback_3', 'ep_fee' => nil, 'deduction_option' => nil },
        { 'file_name_regex' => /.*PUBLIX/, 'date_regex' => nil,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => 'invoice_date_9', 'chargeback_option' => 'chargeback_4', 'ep_fee' => 'admin_fee_1', 'deduction_option' => 'deduction_description' },
        { 'file_name_regex' => /FSRTFM\d{2}\d{2}.*PB/, 'date_regex' => /FSRTFM(....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_2', 'ep_fee' => 'admin_fee_3', 'deduction_option' => nil },
        { 'file_name_regex' => /FSRTFMGR[a-z]{3}\d{2}.*/i, 'date_regex' => /FSRTFMGR(.....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_2', 'ep_fee' => 'admin_fee_3', 'deduction_option' => nil },
        { 'file_name_regex' => /FSRTFMGR\d{2}\d{2}.*/, 'date_regex' => /FSRTFMGR(....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_2', 'ep_fee' => 'admin_fee_3', 'deduction_option' => nil },
        { 'file_name_regex' => /FSRTFM\d{2}\d{2}.*/, 'date_regex' => /FSRTFM(....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_2', 'ep_fee' => 'admin_fee_4', 'deduction_option' => nil },
        { 'file_name_regex' => /.*TFM/, 'date_regex' => nil,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => 'invoice_date_10', 'chargeback_option' => 'chargeback_1', 'ep_fee' => 'admin_fee_1', 'deduction_option' => 'deduction_description' },
        { 'file_name_regex' => /ERDC\d{2}\d{2}.*/, 'date_regex' => /ERDC(....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_4', 'ep_fee' => nil, 'deduction_option' => nil },
        { 'file_name_regex' => /EROSF\w{4}.*/, 'date_regex' => /EROSF(....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_3', 'ep_fee' => nil, 'deduction_option' => nil },
        { 'file_name_regex' => /ERNACVTN\d{2}\d{2}.*/, 'date_regex' => /ERNACVTN(....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_4', 'ep_fee' => nil, 'deduction_option' => nil },
        { 'file_name_regex' => /ERVELCTY\d{2}\d{2}.*/, 'date_regex' => /ERVELCTY(....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_3', 'ep_fee' => nil, 'deduction_option' => nil },
        { 'file_name_regex' => /CONACT\d{2}\d{2}.*/, 'date_regex' => /CONACT(....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_4', 'ep_fee' => nil, 'deduction_option' => nil },
        { 'file_name_regex' => /WRVELCTY\d{2}\d{2}.*/, 'date_regex' => /WRVELCTY(....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_3', 'ep_fee' => nil, 'deduction_option' => nil },
        { 'file_name_regex' => /SBM\d{2}\d{2}.*/, 'date_regex' => /SBM(....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_4', 'ep_fee' => nil, 'deduction_option' => nil },
        { 'file_name_regex' => /URMTO.*HCM/, 'date_regex' => nil,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => ['month_mcb_type', 'invoice_date_6'], 'chargeback_option' => 'chargeback_4', 'ep_fee' => nil, 'deduction_option' => nil },
        { 'file_name_regex' => /NSOWKF.*HCM/, 'date_regex' => nil,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => 'invoice_date_11', 'chargeback_option' => 'chargeback_3', 'ep_fee' => nil, 'deduction_option' => nil },
        { 'file_name_regex' => /FSRWGM[a-z]{3}\d{2}.*/i, 'date_regex' => /FSRWGM(.....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_4', 'ep_fee' => nil, 'deduction_option' => nil },
        { 'file_name_regex' => /FSRWGM\d{2}\d{2}.*/, 'date_regex' => /FSRWGM(....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_4', 'ep_fee' => nil, 'deduction_option' => nil },
        { 'file_name_regex' => /.*WEGMNS/, 'date_regex' => nil,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => 'invoice_date_6', 'chargeback_option' => 'chargeback_1', 'ep_fee' => nil, 'deduction_option' => 'deduction_description' },
        { 'file_name_regex' => /.*WINDIXPB/, 'date_regex' => nil,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_4', 'ep_fee' => nil, 'deduction_option' => nil },
        { 'file_name_regex' => /.*WINDIX/, 'date_regex' => nil,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => 'invoice_date_12', 'chargeback_option' => 'chargeback_4', 'ep_fee' => nil, 'deduction_option' => 'deduction_description' },
        { 'file_name_regex' => /KGFSR\d{2}\d{2}.*/, 'date_regex' => /KGFSR(....)/,'invoice_number_option' => 'invoice_number_1', 'invoice_date_option' => nil, 'chargeback_option' => 'chargeback_2', 'ep_fee' => nil, 'deduction_option' => nil }
      ]


      def parser_rule_match(file_name)
        PARSER_RULE_OPTIONS.each do |rule|
          return rule if file_name.try(:match?, rule['file_name_regex'])
        end
        nil
      end

      def file_name(document)
        document.try(:[], 'file_name')
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

      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document)).deep_merge(
        parsed_deduction_description(document))
      end

      def parsed_invoice_number(document)
        invoice_number = parsed_invoice_number_string(document)
        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_number_string(document)
        invoice_number = parsed_rule(document, 'invoice_number_option')
        file_name = document['file_name']
        match_to_file_name(invoice_number, file_name, 5)

        # case file_name
        # when /FSRGE\d{2}\d{2}.*A/
        #   match_to_file_name(invoice_number, file_name, 5)
        # when /FSRTFMGR\d{2}\d{2}.*/
        #   match_to_file_name(invoice_number, file_name, 5)
        # when /EROSF\w{4}.*/
        #   match_to_file_name(invoice_number, file_name, 5)
        # else
        #   invoice_number
        # end
      end

      def parsed_deduction_description(document)
        deduction_description = parsed_rule(document, 'deduction_option')
        {'deduction_description' => deduction_description}
      end

      def parsed_invoice_date(document)
        invoice_date_rule = parser_rule_option(document, 'invoice_date_option')
        if invoice_date_rule.class == Array
          first_rule = invoice_date_rule.try(:first)
          second_rule = invoice_date_rule.try(:last)
          date_str = parsed_invoice_date_string(document, first_rule)
          date_str = is_date?(date_str) ? date_str : parsed_invoice_date_string(document, second_rule)
          start_date, end_date = str_to_dates(date_str)
        elsif invoice_date_rule.class == String
          date_str = parsed_invoice_date_string(document, invoice_date_rule)
          start_date, end_date = str_to_dates(date_str)
        elsif invoice_date_rule.nil?
          date_regex = parser_date_regex(document)
          start_date = end_date = nil if !date_regex
          date_string = file_name(document).try(:scan, date_regex).try(:flatten).try(:first)
          dates = date_string_to_promo_dates(date_string)
          start_date, end_date = dates.try(:values)
        else
          start_date = end_date = nil
        end

        { 'start_date' => start_date, 'end_date' => end_date }
      end

      def parsed_invoice_date_string(document, invoice_date_rule)
        case invoice_date_rule
        when 'invoice_date_6'
          document.try(:[], invoice_date_rule).try(:last).try(:values).try(:first)
        when 'invoice_date_8'
          dates_arr = document.try(:[], invoice_date_rule)
          dates = dates_arr.map{|d| d.values.first} if dates_arr
          "#{dates.try(:min)} #{dates.try(:max)}"
        else
          parsed_data(document, invoice_date_rule)
        end
      end

      def str_to_dates(str)
        return nil if !str
        dates = str.try(:scan, /\d{1,4}\/\d{1,4}\/\d{1,4}/)

        if dates.try(:count) > 1
          start_date, end_date = dates
        else
          start_date = end_date = dates.try(:first)
        end

        [start_date, end_date]
      end

      def is_date?(str)
        str.try(:match?, /\d{1,4}\/\d{1,4}\/\d{1,4}/)
      end

      #admin fee: first try admin_fee_3. MIN of smaller number in admin_fee_2 if 2 numbers exist, otherwise, try admin fee 3
      def parsed_totals(document)
        chargeback_option = parser_rule_option(document, 'chargeback_option')
        ep_fee_option = parser_rule_option(document, 'ep_fee')

        { 'chargeback_amount' => apply_chargeback_options(document, chargeback_option),
          'ep_fee' => apply_ep_fee_options(document, ep_fee_option) }
      end

      def apply_chargeback_options(document, chargeback_option)
        return nil if !chargeback_option
        chargeback_arr = document.try(:[], chargeback_option)
        return nil if !chargeback_arr
        arr = chargeback_arr.map do |h|
          str_to_dollars(h.try(:values).try(:first))
        end
        arr.try(:max)
      end

      def apply_ep_fee_options(document, ep_fee_option)
        ep_fee_arr = document.try(:[], ep_fee_option)
        return nil if !ep_fee_option || !ep_fee_arr
        case ep_fee_option
        when 'admin_fee_1'
          parsed_data(document, 'admin_fee_1')
        when 'admin_fee_4'
          parsed_data(document, 'admin_fee_4')
        when 'admin_fee_2'
          option_admin_fee_2_or_3(ep_fee_arr)
        when 'admin_fee_3'
          option_admin_fee_2_or_3(ep_fee_arr)
        end
      end

      def option_admin_fee_2_or_3(ep_fee_arr)
        arr = ep_fee_arr.map do |h|
          str_to_dollars(h.try(:values).try(:first))
        end
        arr.try(:min)
      end
    end
  end
end
