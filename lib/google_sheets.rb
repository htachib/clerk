class GoogleSheets
  require 'google/apis/sheets_v4'
  require 'googleauth'
  require 'googleauth/stores/file_token_store'
  require 'fileutils'

  APPLICATION_NAME = 'Google Sheets API Ruby Quickstart'.freeze
  OOB_URI = 'https://f256f093.ngrok.io/oauth2callback'
  # The file token.yaml stores the user's access and refresh tokens, and is
  # created automatically when the authorization flow completes for the first
  # time.
  TOKEN_PATH = 'config/initializers/drive_auth_token.yaml'.freeze
  SCOPES = [
      'https://www.googleapis.com/auth/drive',
      'https://spreadsheets.google.com/feeds/',
      'https://www.googleapis.com/auth/spreadsheets.readonly'
  ].freeze

  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization. If authorization is required,
  # the user's default browser will be launched to approve the request.
  #
  def self.authorize
    # client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
    client_id = Google::Auth::ClientId.new(ENV['GOOGLE_DRIVE_APP_CLIENT_ID'], ENV['GOOGLE_DRIVE_APP_CLIENT_SECRET'])
    token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPES, token_store)
    user_id = 'default'
    # credentials = authorizer.get_credentials(user_id)
    credentials = nil # force recreation
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: OOB_URI)
      puts 'Open the following URL in the browser and enter the ' \
           "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials
  end

  # Initialize the API
  def self.client
    service = Google::Apis::SheetsV4::SheetsService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize
    service
  end

  # Prints the names and majors of students in a sample spreadsheet:
  # https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit

  # client = GoogleSheets.client
  # spreadsheet_id = '1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms'
  # range = 'Class Data!A2:E'
  # response = client.get_spreadsheet_values(spreadsheet_id, range)
  # puts 'No data found.' if response.values.empty?
  # response.values.each do |row|
  #   # Print columns A and E, which correspond to indices 0 and 4.
  #   puts "#{row[0]}, #{row[4]}"
  # end
end
