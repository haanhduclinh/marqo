module Marqo
  class Device
    class << self
      # https://docs.marqo.ai/1.2.0/API-Reference/models/
      def cpu(endpoint)
        url = Marqo::UrlHelpers.device_cpu_endpoint(endpoint)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = url.scheme == "https"
        request = Net::HTTP::Get.new(url)

        http.request(request)
      end

      def cuda(endpoint)
        url = Marqo::UrlHelpers.device_cuda_endpoint(endpoint)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = url.scheme == "https"
        request = Net::HTTP::Get.new(url)

        http.request(request)
      end
    end
  end
end
