module Parsers
  class UnfiWest
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

      def parse_row(document)
        data = document['invoice_details'].map {|row| row.values }
        invoice_headers = data[0]
        category_sections = divide_by_section(data)
        data_by_section = sort_section(category_sections, invoice_headers)
        parser_headers = ['MCB Category', data_by_section.first.values.first[:customers].first.keys - ['invoices'], invoice_headers].flatten

        get_rows(data_by_section)
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
          if row.join.match?(/(Category [A-Z]+)/)
            new_category = add_category(row)
            parsed_data[new_category] = {"customers": []}
            current_category_id = new_category
          elsif row.join.match?(/Customer Totals /)
            next
          elsif row.join.match?(/Customer /)
            new_customer = add_customer(row)
            parsed_data[current_category_id][:customers] << new_customer
            current_customer_id = parsed_data[current_category_id][:customers].length - 1
          elsif row[9].strip == '%' || row[8].strip == '%'
            next
          elsif row[9].include?('MCB%')
            next
          elsif row[9].include?('%') || row[8].include?('%')
            parsed_data[current_category_id][:customers][current_customer_id]['invoices'] << add_invoice(row, invoice_headers)
          end
        end
        return parsed_data
      end

      def add_category(row)
        return row.join.split(' ')[1]
      end

      def add_customer(row)
        customer = {}
        id = /\[(.*?)\]/.match(row.join)[1]
        abbreviation = /\((.*?)\)/.match(row.join)[1]
        location = /\(.*?\) ([\s\S]*)/.match(row.join)[1]
        city = location.split(',')[0]
        state = location.split(',')[1].strip
        details = row.join.split("Customer : ")[1]

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
