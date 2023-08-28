# frozen_string_literal: true

module Marqo
  class Document
    class << self
      # https://docs.marqo.ai/1.2.0/API-Reference/documents/#add-or-replace-documents
      def create(endpoint, index_name, documents, options = {})
        url = URI.join(endpoint, 'indexes/', "#{index_name}/", 'documents')

        http = Net::HTTP.new(url.host, url.port)
        request = Net::HTTP::Post.new(url)
        request['Content-type'] = 'application/json'

        request_body = {
          documents: documents
        }

        request_body[:tensorFields] = options[:tensor_fields] if options[:tensor_fields].count.positive?

        request.body = JSON.dump(request_body)

        http.request(request)
      end

      # https://docs.marqo.ai/1.2.0/API-Reference/documents/#get-one-document
      def find(endpoint, index_name, document_id, options = {})
        url = URI.join(endpoint, 'indexes/', "#{index_name}/", 'documents/', document_id)

        http = Net::HTTP.new(url.host, url.port)
        request = Net::HTTP::Get.new(url)

        if options[:expose_facets]
          params = { 'expose_facets' => options[:expose_facets] }
          request.set_form_data(params)
          request = Net::HTTP::Get.new("#{url.path}?#{request.body}")
        end

        http.request(request)
      end

      # https://docs.marqo.ai/1.2.0/API-Reference/documents/#get-multiple-documents
      def finds(endpoint, index_name, document_ids, _options = {})
        url = URI.join(endpoint, 'indexes/', "#{index_name}/", 'documents')

        http = Net::HTTP.new(url.host, url.port)
        request = Net::HTTP::Get.new(url)
        request['Content-Type'] = 'application/json'

        request.body = JSON.dump(document_ids)

        http.request(request)
      end
    end
  end
end
