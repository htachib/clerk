class SpreadsheetService
  attr_accessor :session
  attr_accessor :user

  def initialize(user = nil)
    @session = client
    @user = user ||= User.find_by(email: User::ADMIN_EMAIL)
  end

  def import_data
    Parser.active.each do |parser|
      parser_id = parser.external_id # pointer to docparser process
      sheet_id = parser.destination_id # pointer to google spreadsheet

      documents = get_documents(parser_id)

      documents.each do |document|
        doc = prepare_doc(parser, document)
        next if doc.processed?

        # todo, could check spreadsheet headers and ensure they match?
        data = parse_and_prepare_rows(document, parser_id) # parses and prepares rows
        doc.process! if add_rows(sheet_id, data) # returns true/false
      end
    end
  end

  def prepare_doc(parser, document)
    external_id = document.try(:id) || document.dig('id') # sheet, docparser
    name = document.try(:name) || document.dig('file_name')

    parser.documents.find_or_create_by(external_id: external_id, name: name)
  end

  def get_documents(parser_id)
    case parser_id
      when '1Z5by0rrvu1tVw5K2nXZRAJL3ct2TM7GS' # Unfi Easy Weekly MCB
        fetch_documents_from_folder(parser_id)
      else
        # TODO: only fetch documents where created_at > last import
        DocParserService.fetch_documents(parser_id)
    end
  end

  def add_rows(sheet_id, data) # ['bob', 'jimbob@gmail.com', false, '2/01/2019']
    sheet = fetch_by_key(sheet_id)
    new_row = sheet.num_rows + 1
    data = data.count == data.flatten.count ? [data] : data # single + multiple row collections
    sheet.insert_rows(new_row, data)
    sheet.save
  end

  # TODO: case statement to combines 'rules' for each doc, ie 'meta_data' + 'line_items'
  # could store the 'keys' inside `parser.rules = {}`
  def parse_and_prepare_rows(document, parser_id)
    case parser_id
      when '1Z5by0rrvu1tVw5K2nXZRAJL3ct2TM7GS'
        raw_rows = Parsers::UNFIEastWeeklyMCB.parse_rows(document)
        Mappers::UNFIEastWeeklyMCB.prepare_rows(raw_rows)
      when 'xvexmuksclhe'
        raw_rows = Parsers::UNFIWestWeeklyMCB.parse_rows(document)
        Mappers::UNFIWestWeeklyMCB.prepare_rows(raw_rows)
      when 'eylfucfqzted'
        raw_rows = Parsers::UNFIEastChargeback.parse_rows(document)
        Mappers::UNFIEastChargeback.prepare_rows(raw_rows)
      when 'enowqxdfgcqg'
        raw_rows = Parsers::UNFIEastDeductionQuarterly.parse_rows(document)
        Mappers::UNFIEastDeductionQuarterly.prepare_rows(raw_rows)
      when 'azwkpkgfxroi'
        raw_rows = Parsers::UNFIEastReclamation.parse_rows(document)
        Mappers::UNFIEastReclamation.prepare_rows(raw_rows)
      when 'unkxjvdpcdwg'
        raw_rows = Parsers::KeheWeeklyMCB.parse_rows(document)
        Mappers::KeheWeeklyMCB.prepare_rows(raw_rows)
      when 'hkoarkqejsvb'
        raw_rows = Parsers::KeheLateDeliveryFee.parse_rows(document)
        Mappers::KeheLateDeliveryFee.prepare_rows(raw_rows)
      when 'bqwnqipeffxj'
        raw_rows = Parsers::KehePassThroughPromotion.parse_rows(document)
        Mappers::KehePassThroughPromotion.prepare_rows(raw_rows)
      when 'yajcqtqeuwhd'
        raw_rows = Parsers::KehePromotion.parse_rows(document)
        Mappers::KehePromotion.prepare_rows(raw_rows)
      when 'hjczbplazgti'
        raw_rows = Parsers::KeheSlotting.parse_rows(document)
        Mappers::KeheSlotting.prepare_rows(raw_rows)
    end
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
