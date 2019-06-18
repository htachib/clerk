module Parsers
  class KeheWeeklyMCB < Base
    class << self
      INVOICE_HEADERS = ["UPC#", "QTY SHIP", "DESCRIPTION", "REFERENCE NBR", "REFERENCE DATE", "COMMENT", "COST", "DISC $ OR %", "EXT-COST"]

      def parse_rows(document)
        invoice_dates = raw_invoice_dates(document)
        invoice_rows = invoice_data(document).map do |row|
          merge_rows(row, document, invoice_dates)
        end
        processing_fee_row = processing_fee(document, invoice_dates)
        new_row = merge_rows(processing_fee_row, document, invoice_dates)
        invoice_rows.push(new_row)
      end

      def merge_rows(row, document, invoice_dates)
        row.deep_merge(invoice_dates[0]
        ).deep_merge(invoice_dates[1]
        ).deep_merge('file_name' => document['file_name']
        ).deep_merge(
        'uploaded_at' => document['uploaded_at']
        )
      end

      def processing_fee(document, invoice_dates)
        totals = document['totals']
        fee = totals[2].values.last
        {'processing_fee' => fee}
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
        starting_row_idx = category_starting_rows(data)
        row_counter = starting_row_idx[0]

        starting_row_idx.each.with_index do |row_num, idx|
          ending_row_idx = (idx == starting_row_idx.length - 1) ? -1 : starting_row_idx[idx + 1] - 1
          category_sections << data[row_num..ending_row_idx]
        end

        category_sections
      end

      def sort_section(category_sections)
        category_sections.map do |section|
          parse_section(section)
        end.flatten
      end

      def parse_header(rows)
        header = {}
        header['SEND TO'] = rows['first'].join().split(':').last
        header['ADDRESS'] = rows['second'].join.split('TOL').first
        header['TOL User'] = rows['second'].join.split(': ').last
        header['Customer ID'] = rows['third'].first
        location = rows['third'].join.split(/^\d+/).last.split('TELEPHONE').first
        city_state = location.match(/[a-zA-Z]+/)[0]
        header['city'] = city_state[0..-3]
        header['state'] = city_state[-2..-1]
        header['telephone'] = rows['third'].join.split('TELEPHONE: ').last
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
        meta_data = document['invoice_dates'][0]['key_0']
        dates = meta_data.scan(/\d{2}\/\d{2}\/\d{4}/)
        return [{'start_date' => dates[0]},{'end_date' => dates[1]}]
      end

      def parse_section(section)
        parsed_data = []
        header_rows = identify_header_rows(section)
        body_rows = identify_body_rows(section)

        section_header = parse_header(header_rows)
        section_body = parse_body(body_rows)

        section_body.each do |line|
          transaction = section_header.deep_merge(line)
          parsed_data.push(transaction)
        end
        return parsed_data
      end

      def identify_header_rows(section)
        header_rows = {}
        section.each do |row|
          row_string = row.join()
          header_rows['first'] = row if row_string.match?(/sold.*to:/i)
          header_rows['second'] = row if row_string.match?(/tol.*user/i)
          header_rows['third'] = row if row_string.match?(/telephone:/i)
        end
        header_rows
      end

      def identify_body_rows(section)
        body_rows = []
        section.each do |row|
          last_column = row.last
          body_rows.push(row) if last_column.match?(/\d+/)
        end
        body_rows
      end
    end
  end
end
