require 'rails_helper'

describe SpreadsheetService do
  before do
    allow_any_instance_of(Google::Auth::UserRefreshCredentials).to receive(:fetch_access_token!).and_return({})

    stub_request(:get, "https://api.docparser.com/v1/results/eylfucfqzted?api_key=ea69446c9b43ec90559a3f271ec0eb0e06e711a0").
      to_return(status: 200, body: "", headers: {})
  end

  subject { described_class.new(create(:user)) }

  describe '#import_data' do
    it 'should import documents and upload data to Google Sheets' do
      expect {
        subject.import_data!
      }.to change { Parser.count }.by(0) # TODO: stub content
    end

    it 'should return user' do
      expect(subject.user).to eql User.last
    end
  end
end
