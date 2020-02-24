require 'rails_helper'

describe SpreadsheetService do
  before do
    # stub documents from DocParser
    stub_request(:get, /https:\/\/api.docparser.com\/v1\/results\/.*\?api_key=.*/).
      to_return(status: 200, body: json_fixture('docparser/documents').to_json, headers: {})

    # stub Google Drive connection
    allow_any_instance_of(Google::Auth::UserRefreshCredentials).to receive(:fetch_access_token!).and_return({})
    dummy_session = OpenStruct.new({spreadsheet_by_key: true})
    dummy_workbook = OpenStruct.new({append: true})
    allow(dummy_session).to receive(:spreadsheet_by_key).with(/.*/).and_return dummy_workbook
    allow(dummy_workbook).to receive(:append).with(any_args).and_return true
    allow_any_instance_of(SpreadsheetService).to receive(:client).and_return(dummy_session)

    create(:parser)
  end

  subject { described_class.new(create(:user)) }

  describe '#import_data' do
    it 'should import documents and upload data to Google Sheets' do
      expect {
        subject.import_data!
      }.to change { Document.processed.count }.by(1)
    end

    it 'should not import the same documents twice' do
      subject.import_data!

      expect {
        subject.import_data!
      }.to change { Document.count }.by(0)
    end
  end
end
