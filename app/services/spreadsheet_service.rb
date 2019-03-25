class SpreadsheetService
  attr_accessor :session
  attr_accessor :user

  def initialize(user)
    @session = client
    @user = user
  end

  def import_data
    active_parsers.each do |parser|
      parser_id = parser.external_id
      sheet_id = parser.destination_id

      parser = user.parsers.find_or_create_by(external_id: parser_id, destination_id: sheet_id)
      documents = DocParserService.fetch_documents(parser_id)

      documents.each do |document|
        doc = parser.documents.find_or_create_by(external_id: document.dig('id'), name: document.dig('file_name'))
        next if doc.processed?

        # todo, could check spreadsheet headers and ensure they match?
        data = parse_and_prepare_rows(document, parser_id) # parses and prepares rows
        doc.process! if add_rows(sheet_id, data) # returns true/false
      end
    end
  end

  def add_rows(sheet_id, data) # ['bob', 'jimbob@gmail.com', false, '2/01/2019']
    sheet = fetch_by_key(sheet_id)
    new_row = sheet.num_rows + 1
    data = data.count == data.flatten.count ? [data] : data # single + multiple row collections
    sheet.insert_rows(new_row, data)
    sheet.save
  end

  # v2.0 - insert to prod DB then DELETE this
  # def parsers
  #   sheet_id = '1UnsCVq6dIQXIlQnDI4MaKXW2Vqp8QzYONuYn4o5UGvI' # master
  #   [
  #     { destination_id: sheet_id, external_id: 'eylfucfqzted' }, # cas chargeback
  #     { destination_id: sheet_id, external_id: 'enowqxdfgcqg' }, # eagle
  #     { destination_id: sheet_id, external_id: 'xvexmuksclhe' }  # unfi west
  #   ]
  # end

  def active_parsers
    Parser.where.not(destination_id: nil)
  end

  # TODO: case statement to combines 'rules' for each doc, ie 'meta_data' + 'line_items'
  # could store the 'keys' inside `parser.rules = {}`
  def parse_and_prepare_rows(document, parser_id)
    case parser_id
      when 'xvexmuksclhe'
        raw_rows = Parsers::UNFIWestWeeklyMCBReport.parse_rows(document)
        Mappers::UNFIWestWeeklyMCBReport.prepare_rows(raw_rows)
      when 'eylfucfqzted'
        raw_rows = Parsers::UNFIEastChargeback.parse_rows(document)
        Mappers::UNFIEastChargeback.prepare_rows(raw_rows)
      when 'enowqxdfgcqg'
        raw_rows = Parsers::UNFIEastDeductionInvoice.parse_rows(document)
        Mappers::UNFIEastDeductionInvoice.prepare_rows(raw_rows)
      when 'azwkpkgfxroi'
        raw_rows = Parsers::UNFIEastReclamation.parse_rows(document)
        Mappers::UNFIEastReclamation.prepare_rows(raw_rows)
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
