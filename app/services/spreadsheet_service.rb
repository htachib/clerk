class SpreadsheetService
  attr_accessor :session
  attr_accessor :user

  def initialize(user)
    @session = client
    @user = user
  end

  def import_data
    parsers.each do |parser|
      parser_id = parser[:parser_id]
      sheet_id = parser[:sheet_id]

      parser = user.parsers.find_or_create_by(external_id: parser_id)
      documents = DocParserService.fetch_documents(parser_id)

      documents.each do |document|
        doc = parser.documents.find_or_create_by(external_id: document.dig('id'), name: document.dig('file_name'))
        next if doc.processed?

        # todo, could check spreadsheet headers and ensure they match?
        data = prepare_row(document)
        doc.process! if add_row(sheet_id, data) # returns true/false
      end
    end
  end

  def add_row(sheet_id, data) # ['bob', 'jimbob@gmail.com', false, '2/01/2019']
    sheet = fetch_by_key(sheet_id)
    new_row = sheet.num_rows + 1
    sheet.insert_rows(new_row, [data])
    sheet.save
  end

  # todo: replace with iteration through 'parsers' table!
  def parsers
    [
      { sheet_id: '1dEdAAXzfsIOkhympf7AHeIB7nEyQBpDVgo8ZO5StPsA', parser_id: 'eylfucfqzted' }, # cas chargeback
      { sheet_id: '1yf0tGmzWeW3yNJw0w9M4Vr1parHiqv6l7BQ1drrJIrE', parser_id: 'enowqxdfgcqg' }, # eagle
      # { sheet_id: '1PjDZmbrvWZ04gGUGp7Lmwfps6mcOc', parser_id: 'xvexmuksclhe' }  # not ready - unfi west
    ]
  end

  # todo: case statement to combines 'rules' for each doc, ie 'meta_data' + 'line_items'
  # could store the 'keys' inside `parser.rules = {}`
  def prepare_row(document)
    data = {}
    prepare_meta(document, data)
    prepare_body(document, data)

    data.values # ignore headers
  end

  # single item sections
  def prepare_meta(document, data)
    ['invoice_summary', 'meta_data', 'invoice_details'].each do |section|
      next if document[section].blank?
      data.deep_merge!(document[section][0])
    end
  end

  # multi item sections
  def prepare_body(document, data)
    ['line_items'].each do |section|
      next if document[section].blank?
      document[section].each do |line_item|
        data.deep_merge!(line_item.values)
      end
    end
  end

  def fetch_by_key(sheet_id)
    session.spreadsheet_by_key(sheet_id).worksheets[0]
  end

  def create_sheet(folder_id, sheet_name) # '0BwwA4oUTeiV1TGRPeTVjaWRDY1E'
    session.create_spreadsheet(sheet_name)
  end

  def client
    credentials.fetch_access_token!
    GoogleDrive::Session.from_credentials(credentials)
  end

  def credentials
    Google::Auth::UserRefreshCredentials.new(
      client_id: ENV['GOOGLE_DRIVE_APP_CLIENT_ID'],
      client_secret: ENV['GOOGLE_DRIVE_APP_CLIENT_SECRET'],
      scope: GoogleSheets::SCOPES,
      refresh_token: ENV['GOOGLE_DRIVE_REFRESH_TOKEN']
    )
  end
end
