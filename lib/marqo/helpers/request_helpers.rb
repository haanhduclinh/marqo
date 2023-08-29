module Marqo
  module RequestHelpers
    module_function

    def generate_search_payload(query, options)
      defaul_options = {
        limit: 20,
        offset: 0,
        showHighlights: true,
        searchMethod: Marqo::Search::SEARCH_METHOD_TENSOR,
        attributesToRetrieve: ['*'],
        image_download_headers: {}
      }.merge(options)

      defaul_options.merge(q: query)
    end
  end
end
