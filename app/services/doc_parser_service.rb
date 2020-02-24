class DocParserService
  BASE_URL = 'https://api.docparser.com/v1'.freeze

  class << self
    def fetch_documents(parser_id, limit = 200)
      resp = HTTParty.get(results_url(parser_id) + filters(limit))
      resp.success? ? JSON.parse(resp.body) : []
    end

    def results_url(parser_id)
      BASE_URL + "/results/#{parser_id}"
    end

    # TODO: only fetch documents where created_at > last import
    def filters(limit)
      "?api_key=#{ENV['DOC_PARSER_API_KEY']}&limit=#{limit}"
    end
  end
end
