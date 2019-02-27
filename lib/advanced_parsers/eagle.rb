module AdvancedParsers
  class Eagle
    class << self

      def prepare_row(document)
        meta_data = document['meta_data'][0]
        invoice_summary = document['invoice_summary'][0]
        invoice_details = document['invoice_details']

        summary = meta_data.deep_merge(invoice_summary)

        if invoice_details.blank? # summary only
          summary.values
        else # multiple line item coverage
          invoice_details.map do |line_item|
            summary.deep_merge(line_item).values
          end
        end
      end
    end
  end
end
