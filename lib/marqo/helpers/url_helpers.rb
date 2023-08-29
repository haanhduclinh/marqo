module Marqo
  module UrlHelpers
    module_function

    def index_endpoint(endpoint)
      URI.join(endpoint, 'indexes')
    end

    def create_index_endpoint(endpoint, index_name)
      URI.join(endpoint, 'indexes/', index_name)
    end

    def delete_index_endpoint(endpoint, index_name)
      URI.join(endpoint, 'indexes/', index_name)
    end

    def refresh_endpoint(endpoint, index_name)
      URI.join(endpoint, 'indexes/', "#{index_name}/", "refresh")
    end

    def delete_document_endpoint(endpoint, index_name)
      URI.join(endpoint, 'indexes/', "#{index_name}/", 'documents/', 'delete-batch')
    end

    def find_document_endpoint(endpoint, index_name, document_id)
      URI.join(endpoint, 'indexes/', "#{index_name}/", 'documents/', document_id)
    end

    def base_document_endpoint(endpoint, index_name)
      URI.join(endpoint, 'indexes/', "#{index_name}/", 'documents')
    end

    def search_endpoint(endpoint, index_name)
      URI.join(endpoint, 'indexes/', "#{index_name}/", 'search')
    end

    def health_endpoint(endpoint, index_name)
      URI.join(endpoint, 'indexes/', "#{index_name}/", "health")
    end

    def models_endpoint(endpoint)
      URI.join(endpoint, 'models')
    end

    def device_cpu_endpoint(endpoint)
      URI.join(endpoint, 'device/', 'cpu')
    end

    def device_cuda_endpoint(endpoint)
      URI.join(endpoint, 'device/', 'cuda')
    end
  end
end
