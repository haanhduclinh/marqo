# frozen_string_literal: true

RSpec.describe Marqo::Device do
  context '.cpu' do
    before do
      url = Marqo::UrlHelpers.device_cpu_endpoint(endpoint)
      stub_request(:get, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          }
        ).to_return(status: 200, body: expected_response.to_json, headers: {})
    end

    let(:endpoint) { 'http://localhost:8882' }
    let(:expected_response) do
      {
        cpu_usage_percent: "1.0 %",
        memory_used_percent: "70.0 %",
        memory_used_gb: "11.2"
      }
    end

    it 'returns ok' do
      res = Marqo::Device.cpu(endpoint)
      expect(res.code).to eq('200')
    end
  end

  context '.cuda' do
    before do
      url = Marqo::UrlHelpers.device_cuda_endpoint(endpoint)
      stub_request(:get, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          }
        ).to_return(status: 200, body: expected_response.to_json, headers: {})
    end

    let(:endpoint) { 'http://localhost:8882' }
    let(:expected_response) do
      {
        cuda_devices: [
          {
            device_id: 0,
            device_name: "Tesla T4",
            memory_used: "1.7 GiB",
            total_memory: "14.6 GiB"
          }
        ]
      }
    end

    it 'returns ok' do
      res = Marqo::Device.cuda(endpoint)
      expect(res.code).to eq('200')
    end
  end
end
