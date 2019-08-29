module Parsers
  class UNFIEastWeeklyMCB < Base
    class << self
      def parse_rows(document)
        sheet = document.worksheets[0]

        rows = sheet.rows
        headers = rows[0]
        body = rows[1..-1]

        line_with_headers = []
        body.each do |row|
          line = {}
          row.each_with_index do |cell, idx|
            line[headers[idx]] = cell
          end

          line['file_name'] = document.name.try(:gsub,'.CSV', '').try(:gsub,'.csv', '')
          line['uploaded_at'] = document.created_time.strftime("%m/%d/%Y")
          line_with_headers.push(line)
        end

        line_with_headers
        rescue OpenSSL::SSL::SSLError
        # retry
      end
    end
  end
end
