module Parsers
  class KeheMeijerScansChargebackInvoice < Base
    DEDUCTION_DESCRIPTION_TRANSLATIONS = [{"Meyer's" => "Meijer's"}, {'Meyers' => "Meijer's"}, {'Meyer' => "Meijer"}]

    class << self
      def invoice_data(document)
        parsed_invoice_date(document).deep_merge(
        parsed_totals(document)).deep_merge(
        parsed_invoice_number(document)).deep_merge(
        parsed_deduction_description(document))
      end

      def parsed_invoice_number(document)
        is_match = invoice_number_file_name_match?(document, 5)

        invoice_number = is_match ? invoice_num_from_file_name(document) : get_invoice_number(document)

        {'invoice_number' => invoice_number}
      end

      def parsed_invoice_date(document)
        invoice_dates = document['invoice_date'].try(:first)

        {
          'start_date' => invoice_dates['start_date'],
          'end_date' => invoice_dates['end_date']
        }
      end

      def parsed_totals(document)
        totals = get_totals(document)
        chargeback_amount = parsed_chargeback(totals)
        ep_fee_amount = parsed_ep_fee(totals)

        {'chargeback_amount' => chargeback_amount,
          'ep_fee' => ep_fee_amount}
      end

      def parsed_chargeback(totals)
        regex = /scan.*total/i
        get_total_in_dollars(totals, regex)
      end

      def parsed_ep_fee(totals)
        regex = /ep.*fee/i
        get_total_in_dollars(totals, regex)
      end

      def parsed_deduction_description(document)
        deduction_description = parsed_data(document, 'deduction_description')
        DEDUCTION_DESCRIPTION_TRANSLATIONS.each do |t|
          deduction_description.gsub!(t.keys.first, t.values.first)
        end

        { 'deduction_description' => deduction_description }
      end
    end
  end
end
