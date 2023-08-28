# frozen_string_literal: true

require 'uri'
require 'net/http'

module Marqo
  class Index
    class << self
      # https://docs.marqo.ai/1.2.0/API-Reference/indexes/#list-indexes
      def list(endpoint)
        url = URI.join(endpoint, 'indexes')

        http = Net::HTTP.new(url.host, url.port)
        request = Net::HTTP::Get.new(url)

        http.request(request)
      end

      # https://docs.marqo.ai/1.2.0/API-Reference/indexes/#create-index
      def create(endpoint, index_name, options = {})
        # valid options - default value
        # - index_defaults: ""
        # - number_of_shards: 3
        # - number_of_replicas: 0
        # more detail see in url https://docs.marqo.ai/1.2.0/API-Reference/indexes/
        # example
        # {
        #   "index_defaults": {
        #       "treat_urls_and_pointers_as_images": false,
        #       "model": "hf/all_datasets_v4_MiniLM-L6",
        #       "normalize_embeddings": true,
        #       "text_preprocessing": {
        #           "split_length": 2,
        #           "split_overlap": 0,
        #           "split_method": "sentence"
        #       },
        #       "image_preprocessing": {
        #           "patch_method": null
        #       },
        #       "ann_parameters" : {
        #           "space_type": "cosinesimil",
        #           "parameters": {
        #               "ef_construction": 128,
        #               "m": 16
        #           }
        #       }
        #   },
        #   "number_of_shards": 3,
        #   "number_of_replicas": 0
        # }

        url = URI.join(endpoint, 'indexes/', index_name)

        http = Net::HTTP.new(url.host, url.port)
        request = Net::HTTP::Post.new(url)
        request['Content-type'] = 'application/json'
        request.body = JSON.dump(options) unless options.empty?

        http.request(request)
      end

      # https://docs.marqo.ai/1.2.0/API-Reference/indexes/#delete-index
      def delete(endpoint, index_name)
        url = URI.join(endpoint, 'indexes/', index_name)
        http = Net::HTTP.new(url.host, url.port)
        request = Net::HTTP::Delete.new(url)

        http.request(request)
      end
    end
  end
end
