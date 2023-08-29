module Marqo
  class Models
    class << self
      # https://docs.marqo.ai/1.2.0/API-Reference/models/
      def info(endpoint)
        url = Marqo::UrlHelpers.models_endpoint(endpoint)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = url.scheme == "https"
        request = Net::HTTP::Get.new(url)

        http.request(request)
      end

      def delete(endpoint, params = {})
        url = Marqo::UrlHelpers.models_endpoint(endpoint)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = url.scheme == "https"
        request = Net::HTTP::Delete.new(url)

        unless params.empty?
          request.set_form_data(params)
          request = Net::HTTP::Delete.new("#{url.path}?#{request.body}")
        end

        http.request(request)
      end
    end
  end
end
