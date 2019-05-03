class DocParserService
  API_KEY = ENV['DOC_PARSER_API_KEY']
  BASE_URL = 'https://api.docparser.com/v1'.freeze

  def self.fetch_documents(parser_id)
    url = BASE_URL + "/results/#{parser_id}"
    HTTParty.get(url + "?api_key=#{API_KEY}").parsed_response
  end
end
