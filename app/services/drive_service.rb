class DriveService
  class << self
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

    def add_rows(session, parser, data) # ['bob', 'jimbob@gmail.com', false, '2/01/2019']
      workbook = session.spreadsheet_by_key(parser.destination_id)

      data = data.count == data.flatten.count ? [data] : data # single + multiple row collections

      workbook.append('master!A1', data)
    end

    def get_folder(session, parser)
      folder = session.file_by_id(parser.external_id)
      subfolder_id = parser.settings.dig('subfolder')
      if subfolder_id
        subfolders = folder.subfolders
        folder = subfolders.select{ |f| f.id == parser.settings.dig('subfolder') }.try(:first)
      end
      folder
    end

    def fetch_documents_from_folder(session, parser)
      files = []
      folder = get_folder(session, parser)
      spreadsheets = fetch_spreadsheets_from_folder(folder)
      files.push(spreadsheets).flatten! if !spreadsheets.empty?
      textfiles = fetch_textfiles_from_folder(folder)
      files.push(textfiles)
      files.flatten!
    end

    def fetch_spreadsheets_from_folder(folder)
      sheets = folder.spreadsheets
      sheets.select { |sheet| !sheet.trashed? }
    end

    def includes_textfiles?(files)
      included = false
      files.each do |file|
        included = true if file.name.include?('.TXT') || file.resource_type == 'document'
      end
      included
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

    # useful for debugging; create a new sheet to send data
    def create_sheet(folder_id, sheet_name)
      client.create_spreadsheet(sheet_name)
    end
  end
end
