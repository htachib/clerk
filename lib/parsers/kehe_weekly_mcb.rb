module Parsers
  class KeheWeeklyMCB
    INVOICE_HEADERS = ["UPC#", "QTY SHIP", "DESCRIPTION", "REFERENCE NBR", "REFERENCE DATE", "COMMENT", "COST", "DISC $ OR %", "EXT-COST"]
    class << self
      def parse_rows(document)
        invoice_dates = raw_invoice_dates(document)
        invoice_data(document).map do |row|
          row.deep_merge(invoice_dates[0]
          ).deep_merge(invoice_dates[1]
          ).deep_merge('file_name' => document['file_name']
          ).deep_merge(
          'uploaded_at' => document['uploaded_at']
          )
        end
      end

      def invoice_data(document)
        data = document['invoice_details'].map {|row| row.values }
        category_sections = divide_by_section(data)
        sort_section(category_sections)
      end

      def category_starting_rows(data)
        return data.map.with_index do |row, idx|
          idx if row[0].include?('SOLD TO:')
        end.compact
      end

      def divide_by_section(data)
        category_sections = []
        row_counter = 0
        category_starting_rows(data).each.with_index do |row_num, idx|
          if idx.even?
            row_counter = row_num
          else
            category_sections << data[row_counter..(row_num - 1)]
            row_counter = row_num
          end
        end
        return category_sections
      end

      def sort_section(category_sections)
        category_sections.map do |section|
          parse_section(section)
        end.flatten
      end

      def parse_header(rows)
        header = {}
        header['SEND TO'] = rows[0].join().split(':').last
        header['ADDRESS'] = rows[1].join.split('TOL').first
        header['TOL User'] = rows[1].join.split(': ').last
        header['Customer ID'] = rows[2].first
        location = rows[2].join.split(/^\d+/).last.split('TELEPHONE').first
        city_state = location.match(/[a-zA-Z]+/)[0]
        header['city'] = city_state[0..-3]
        header['state'] = city_state[-2..-1]
        header['telephone'] = rows[2].join.split('TELEPHONE: ').last
        header
      end

      def parse_body(rows)
        body = []
        rows.each do |row|
          line = {}
          row.each_with_index do |cell, idx|
            line[INVOICE_HEADERS[idx]] = cell
          end
          body.push(line)
        end
        body
      end

      def raw_invoice_dates(document)
        meta_data = document['meta_data'][0]['key_0']
        dates = meta_data.scan(/\d{2}\/\d{2}\/\d{4}/)
        return [{'start_date' => dates[0]},{'end_date' => dates[1]}]
      end

      def parse_section(section)
        parsed_data = []
        section_header = parse_header(section[0..2])
        section_body = parse_body(section[6..-1])

        section_body.each do |line|
          transaction = section_header.deep_merge(line)
          parsed_data.push(transaction)
        end
        return parsed_data
      end
    end
  end
end
