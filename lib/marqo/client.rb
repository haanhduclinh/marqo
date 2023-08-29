module Marqo
  class Client
    attr_accessor :endpoint, :index_name

    def initialize(ept = nil, name = nil)
      self.endpoint   = ept  || Marqo.configuration.endpoint
      self.index_name = name || Marqo.configuration.index_name
    end

    def create_index(index_name, options = {})
      Marqo::Index.create(endpoint, index_name, options)
    end

    def list_index
      Marqo::Index.list(endpoint)
    end

    def delete_index
      Marqo::Index.delete(endpoint, index_name)
    end

    def add_documents(documents, options = {})
      Marqo::Document.create(endpoint, index_name, documents, options)
    end

    def find_doc(document_id, options = {})
      Marqo::Document.find(endpoint, index_name, document_id, options)
    end

    def find_docs(document_ids)
      Marqo::Document.finds(endpoint, index_name, document_ids)
    end

    def delete_docs(document_ids)
      Marqo::Document.delete(endpoint, index_name, document_ids)
    end

    def search(query, options = {})
      Marqo::Search.run(endpoint, index_name, query, options)
    end

    def device_cpu
      Marqo::Device.cpu(endpoint)
    end

    def device_cuda
      Marqo::Device.cuda(endpoint)
    end
  end
end
