module Parsers
  class UNFIWestWeeklyMCB < Base
    class << self
      SECTIONS = {
        'A' => 'Ad Deals',
        'C' => 'Show Orders',
        'E' => 'EDLP',
        'F' => 'UNFI NC and HA Circulars',
        'M' => 'New Additions',
        'O' => 'New Store Opening/Placement',
        'P' => 'UNFI Monthly Specials',
        'S' => 'Shelf Sale',
        'T' => 'Turnover',
        'X' => 'Samples',
        'Z' => 'Miscellaneous'
      }

      def parse_rows(document)
        invoice_data(document).map do |row|
          row.deep_merge('file_name' => document['file_name']
          ).deep_merge(
          'uploaded_at' => document['uploaded_at']
          ).deep_merge(
            parsed_invoice_date(document)
          )
        end
      end

      def parsed_invoice_date(document)
        row = get_raw_data(document, 'invoice_date')
        date_string = row.try(:flatten).try(:first)
        date = get_promo_date(date_string)
        start_date = get_promo_start_date(date)
        end_date = get_promo_end_date(date)
        {'start_date' => start_date,
         'end_date' => end_date}
      end

      def get_promo_start_date(input)
        date = input - 6.days
        date.strftime("%m/%d/%Y")
      end

      def get_promo_date(input)
        Date.strptime(input, '%m/%d/%Y')
      end

      def get_promo_end_date(input)
        input.strftime('%m/%d/%Y')
      end

      def invoice_data(document)
        data = document.try(:[], 'invoice_details').map {|row| row.values }
        invoice_headers = data.try(:[], 0)
        category_sections = divide_by_section(data)
        data_by_section = sort_section(category_sections, invoice_headers)
        parser_headers = ['MCB Category', data_by_section.first.values.first[:customers].first.keys - ['invoices'], invoice_headers].flatten
        add_headers_to_data(parser_headers, data_by_section)
      end

      def add_headers_to_data(parser_headers, data_by_section)
        invoice_data = get_rows(data_by_section)
        rows = []

        invoice_data.each do |d|
          row = {}
          parser_headers.count.times do |idx|
            row[parser_headers[idx]] = d[idx]
          end
          rows << row
        end

        rows
      end

      def category_starting_rows(data)
        return data.map.with_index do |row, idx|
          idx if row.join.match?(/(Category ).*/)
        end.compact
      end

      def divide_by_section(data)
        category_sections = []
        row_counter = 0
        category_starting_rows(data).each.with_index do |row_num, idx|
          if idx.even?
            row_counter = row_num
          else
            category_sections << data[row_counter..row_num]
            row_counter = row_num
          end
        end
        return category_sections
      end

      def sort_section(category_sections, invoice_headers)
        category_sections.map do |section|
          parse_section(section, invoice_headers)
        end
      end

      def parse_section(section, invoice_headers)
        parsed_data = {}
        current_customer_id = ''
        current_category_id = ''

        section.each do |row|
          if row.try(:join).try(:match?, /(Category [A-Z]+)/) #row begins new category
            new_category = add_category(row)
            parsed_data[new_category] = {"customers": []}
            current_category_id = new_category
          elsif row.try(:join).try(:match?, /Customer Totals /) #row ends customer section
            next
          elsif row.try(:join).try(:match?, /Customer /) #row begins customer section
            new_customer = add_customer(row)
            parsed_data.try(:[], current_category_id)[:customers] << new_customer
            current_customer_id = parsed_data[current_category_id][:customers].length - 1
          elsif row.try(:[], 9).try(:strip) == '%' || row.try(:[], 8).try(:strip) == '%'
            next
          elsif row.try(:[], 9).try(:include?, 'MCB%') #row is page header
            next
          elsif row.try(:[], 9).try(:include?, '%') || row.try(:[], 8).try(:include?, '%')
            parsed_data[current_category_id][:customers][current_customer_id]['invoices'] << add_invoice(row, invoice_headers)
          end
        end
        return parsed_data
      end

      def add_category(row)
        return row.join.try(:split, ' ').try(:[], 1)
      end

      def add_customer(row)
        customer = {}
        id = /\[(.*?)\]/.match(row.join).try(:[], 1)
        abbreviation = /\((.*?)\)/.match(row.join).try(:[], 1)
        location = /\(.*?\) ([\s\S]*)/.match(row.join).try(:[], 1)
        city = location.try(:split, ',').try(:[], 0)
        state = location.try(:split, ',').try(:[], 1).try(:strip)
        details = row.join.try(:split, "Customer : ").try(:[], 1)

        customer["id"] = id
        customer["abbreviation"] = abbreviation
        customer["location"] = location
        customer["city"] = city
        customer["state"] = state
        customer["details"] = details
        customer["invoices"] = []

        return customer
      end

      def add_invoice(row, invoice_headers)
        invoice_detail = {}
        invoice_headers.length.times do |idx|
          invoice_detail[invoice_headers[idx]] = row[idx]
        end
        return invoice_detail
      end

      def get_rows(data_by_section)
        result = []
        data_by_section.each.with_index do |section, idx|
          section_name = section.keys[0] + ' - ' + SECTIONS[section.keys[0]]
          section.values[0][:customers].each do |customer|
            customer_info = customer.map { |k, v| v if k != 'invoices'}.compact
            customer['invoices'].each do |invoice|
              result << [section_name, customer_info, invoice.values].flatten
            end
          end
        end
        return result
      end
    end
  end
end
