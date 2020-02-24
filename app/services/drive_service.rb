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
  end
end
