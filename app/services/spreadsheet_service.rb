class SpreadsheetService
  attr_accessor :session
  attr_accessor :user

  def initialize(user = nil)
    @session = client
    @user = user ||= User.find_by(email: User::ADMIN_EMAIL)
  end

  def import_data!
    Parser.active.each do |parser|
      documents = get_documents(parser)

      documents.each do |document|
        doc = prepare_doc(parser, document)
        next if doc.processed?

        # todo, could check spreadsheet headers and ensure they match?
        data = parse_and_prepare_rows(document, parser) # parses and prepares rows
        doc.process! if add_rows(parser, data) # returns true/false
      end
    end
  end

  def prepare_doc(parser, document)
    external_id = document_external_id(document)
    file_name = document_file_name(document)

    parser.documents.find_or_create_by(external_id: external_id, name: file_name)
  end

  def document_external_id(document)
    document.try(:id) || document.dig('id') # sheet, docparser
  end

  def document_file_name(document)
    document.try(:name) || document.dig('file_name')
  end

  def get_documents(parser)
    if parser.settings.dig('source') == 'google_drive'
      fetch_documents_from_folder(parser.external_id)
    else # TODO: only fetch documents where created_at > last import
      DocParserService.fetch_documents(parser.external_id)
    end
  end

  def add_rows(parser, data) # ['bob', 'jimbob@gmail.com', false, '2/01/2019']
    sheet = fetch_by_key(parser.destination_id)

    new_row = sheet.num_rows + 1
    data = data.count == data.flatten.count ? [data] : data # single + multiple row collections

    sheet.insert_rows(new_row, data)
    sheet.save
  end

  def parse_and_prepare_rows(document, parser)
    library = parser.settings.dig('library')

    raw_rows = "Parsers::#{library}".constantize.parse_rows(document)
    "Mappers::#{library}".constantize.prepare_rows(raw_rows)
  end

  def fetch_by_key(sheet_id)
    session.spreadsheet_by_key(sheet_id).worksheets[0]
  end

  def fetch_documents_from_folder(folder_id)
    folder = session.file_by_id(folder_id)
    sheets = folder.spreadsheets
    sheets.select { |sheet| !sheet.trashed? }
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
