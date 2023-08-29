# frozen_string_literal: true

RSpec.describe Marqo::Models do
  context '.info' do
    before do
      url = Marqo::UrlHelpers.models_endpoint(endpoint)
      stub_request(:get, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          }
        ).to_return(status: 200, body: expected_response.to_json, headers: {})
    end

    let(:index_name) { 'test' }
    let(:endpoint) { 'http://localhost:8882' }
    let(:expected_response) do
      {
        models: [
          {
            model_name: "hf/all_datasets_v4_MiniLM-L6",
            model_device: "cpu"
          },
          {
            model_name: "hf/all_datasets_v4_MiniLM-L6",
            model_device: "cuda"
          },
          {
            model_name: "ViT-L/14",
            model_device: "cpu"
          },
          {
            model_name: "ViT-L/14",
            model_device: "cuda"
          },
          {
            model_name: "ViT-B/16",
            model_device: "cpu"
          }
        ]
      }
    end

    it 'returns ok' do
      res = Marqo::Models.info(endpoint)
      expect(res.code).to eq('200')
    end
  end

  context '.delete' do
    before do
      url = Marqo::UrlHelpers.models_endpoint(endpoint)
      stub_request(:delete, "#{url}?model_device=cuda&model_name=ViT-L/14")
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          }
        ).to_return(status: 200, body: expected_response.to_json, headers: {})
    end

    let(:params) do
      {
        model_name: 'ViT-L/14',
        model_device: 'cuda'
      }
    end
    let(:index_name) { 'test' }
    let(:endpoint) { 'http://localhost:8882' }
    let(:expected_response) do
      {
        result: "success",
        message: "successfully eject model_name `ViT-L/14` from device `cuda`"
      }
    end

    it 'returns ok' do
      res = Marqo::Models.delete(endpoint, params)
      expect(res.code).to eq('200')
    end
  end
end
