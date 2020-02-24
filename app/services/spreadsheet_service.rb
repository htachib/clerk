class SpreadsheetService
  attr_accessor :session
  attr_accessor :user

  def initialize(user = nil)
    @session = DriveService.client
    @user = user ||= User.find_by(email: User::ADMIN_EMAIL)
  end

  def import_data!
    Parser.active.each do |parser|
      documents = get_documents(parser)

      documents.each do |document|
        doc = prepare_doc(parser, document)
        next if doc.processed?

        data = parse_and_prepare_rows(document, parser) # parses and prepares rows
        next unless data

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
      fetch_documents_from_folder(parser)
    else
      DocParserService.fetch_documents(parser.external_id)
    end
  end

  def add_rows(parser, data) # ['bob', 'jimbob@gmail.com', false, '2/01/2019']
    workbook = session.spreadsheet_by_key(parser.destination_id)

    data = data.count == data.flatten.count ? [data] : data # single + multiple row collections

    workbook.append('master!A1', data)
  end

  def parse_and_prepare_rows(document, parser)
    library = parser.settings.dig('library')

    raw_rows = "Parsers::#{library}".constantize.parse_rows(document)
    "Mappers::#{library}".constantize.prepare_rows(raw_rows)
  rescue StandardError => e
    log_exception(e, document, parser)
    nil
  end

  def log_exception(exception, document, parser)
    ParseMapException.create!(
      parser: parser,
      file_name: document_file_name(document),
      content: document,
      error_message: exception.message
    )
  end

  def fetch_documents_from_folder(parser)
    files = []
    folder = get_folder(parser)
    spreadsheets = fetch_spreadsheets_from_folder(folder)
    files.push(spreadsheets).flatten! if !spreadsheets.empty?
    textfiles = fetch_textfiles_from_folder(folder)
    files.push(textfiles)
    files.flatten!
  end

  def includes_textfiles?(files)
    included = false
    files.each do |file|
      included = true if file.name.include?('.TXT') || file.resource_type == 'document'
    end
    included
  end

  def get_folder(parser)
    folder = session.file_by_id(parser.external_id)
    subfolder_id = parser.settings.dig('subfolder')
    if subfolder_id
      subfolders = folder.subfolders
      folder = subfolders.select{ |f| f.id == parser.settings.dig('subfolder') }.try(:first)
    end
    folder
  end

  def fetch_spreadsheets_from_folder(folder)
    sheets = folder.spreadsheets
    sheets.select { |sheet| !sheet.trashed? }
  end

  def fetch_textfiles_from_folder(folder)
    files = folder.files
    return [] if !includes_textfiles?(files)

    files.map do |file|
      file.export_as_file("#{Rails.root}/#{file.name}")
      content = File.read(file.name)
      { 'id' => file.id, 'file_name' => file.title, 'content' => content, 'uploaded_at' => Date.today }
    end
  end

  def create_sheet(folder_id, sheet_name) # '0BwwA4oUTeiV1TGRPeTVjaWRDY1E'
    session.create_spreadsheet(sheet_name)
  end
end
