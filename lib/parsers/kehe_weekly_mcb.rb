module Parsers
  class KeheWeeklyMCB < Base
    class << self
      INVOICE_HEADERS = ["UPC#", "QTY SHIP", "DESCRIPTION", "REFERENCE NBR", "REFERENCE DATE", "COMMENT", "COST", "DISC $ OR %", "EXT-COST"]

      def parse_rows(document)
        invoice_dates = raw_invoice_dates(document)
        invoice_rows = invoice_data(document).try(:map) { |row| merge_rows(row, document, invoice_dates) } || []
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
        totals = document.try(:[], 'totals')
        fee = totals.try(:[], 2).try(:values).try(:last)
        {'processing_fee' => fee}
      end

      def invoice_data(document)
        data = document['invoice_details'].try(:map) {|row| row.values }
        category_sections = data ? divide_by_section(data) : nil
        sort_section(category_sections)
      end

      def category_starting_rows(data)
        return nil if (!data || data.empty?)
        return data.map.with_index do |row, idx|
          idx if row[0].include?('SOLD TO:')
        end.compact
      end

      def divide_by_section(data)
        category_sections = []
        starting_row_idx = category_starting_rows(data)
        return nil if (!starting_row_idx || starting_row_idx.empty?)

        starting_row_idx.each.with_index do |row_num, idx|
          ending_row_idx = (idx == starting_row_idx.try(:length) - 1) ? -1 : starting_row_idx.try(:[], idx + 1) - 1
          category_sections << data[row_num..ending_row_idx]
        end

        category_sections
      end

      def sort_section(category_sections)
        category_sections.try(:map) { |section| parse_section(section) }.try(:flatten)
      end

      def parse_header(rows)
        header = {}
        header['SEND TO'] = rows.try(:[], 'first').try(:join).try(:split, ':').try(:last)
        header['ADDRESS'] = rows.try(:[], 'second').try(:join).try(:split, 'TOL').try(:first)
        header['TOL User'] = rows.try(:[], 'second').try(:join).try(:split, ': ').try(:last)
        header['Customer ID'] = rows.try(:[], 'third').try(:first)
        location = rows.try(:[], 'third').try(:join).try(:split, /^\d+/).try(:last).to_s.try(:split, 'TELEPHONE').try(:first)
        city_state = location.to_s.match(/[a-zA-Z]+/).try(:[],0)
        header['city'] = city_state ? city_state[0..-3] : nil
        header['state'] = city_state ? city_state[-2..-1] : nil
        header['telephone'] = rows.try(:[], 'third').try(:join).try(:split, 'TELEPHONE: ').try(:last)
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
        return nil if (!section || section.empty?)
        header_rows = identify_header_rows(section) || {}
        body_rows = identify_body_rows(section) || {}

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
          header_rows['first'] = row if row_string.to_s.match?(/sold.*to:/i)
          header_rows['second'] = row if row_string.to_s.match?(/tol.*user/i)
          header_rows['third'] = row if row_string.to_s.match?(/telephone:/i)
        end
        header_rows
      end

      def identify_body_rows(section)
        body_rows = []
        section.each do |row|
          last_column = row.last
          body_rows.push(row) if last_column.to_s.match?(/\d+/)
        end
        body_rows
      end
    end
  end
end
