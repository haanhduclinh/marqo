# frozen_string_literal: true

module Marqo
  class Search
    SEARCH_METHOD_TENSOR = 'TENSOR'
    SEARCH_METHOD_LEXICAL = 'LEXICAL'

    # https://docs.marqo.ai/1.2.0/API-Reference/search/
    def self.run(endpoint, index_name, query, options = {})
      # # possible options
      # filter - https://docs.marqo.ai/1.2.0/API-Reference/search/#filter
      # searchableAttributes - https://docs.marqo.ai/1.2.0/API-Reference/search/#searchable-attributes
      # reRanker - https://docs.marqo.ai/1.2.0/API-Reference/search/#reranker
      # boost - https://docs.marqo.ai/1.2.0/API-Reference/search/#boost
      # context - https://docs.marqo.ai/1.2.0/API-Reference/search/#context
      # score_modifiers - https://docs.marqo.ai/1.2.0/API-Reference/search/#score-modifiers
      # modelAuth - https://docs.marqo.ai/1.2.0/API-Reference/search/#model-auth

      url = Marqo::UrlHelpers.search_endpoint(endpoint, index_name)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = url.scheme == "https"
      request = Net::HTTP::Post.new(url)
      request['Content-type'] = 'application/json'

      payload = Marqo::RequestHelpers.generate_search_payload(query, options)

      request.body = JSON.dump(payload)

      http.request(request)
    end
  end
end
