# frozen_string_literal: true

RSpec.describe Marqo::Index do
  context '.list' do
    before do
      url = Marqo::UrlHelpers.index_endpoint(endpoint)
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
        results: [
          {
            index_name: index_name
          }
        ]
      }
    end

    it 'returns ok' do
      res = Marqo::Index.list(endpoint)
      expect(res.code).to eq('200')
    end
  end

  context '.create' do
    before do
      url = Marqo::UrlHelpers.create_index_endpoint(endpoint, index_name)
      stub_request(:post, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          }
        ).to_return(status: 200, body: expected_response.to_json, headers: {})
    end

    let(:endpoint) { 'http://localhost:8882' }
    let(:options) do
      {
        index_defaults: {
          model: 'hf/all_datasets_v4_MiniLM-L6'
        }
      }
    end
    let(:index_name) { 'test' }
    let(:expected_response) do
      {
        acknowledged: true,
        shards_acknowledged: true,
        index: index_name
      }
    end

    it 'returns ok' do
      res = Marqo::Index.create(endpoint, index_name, options)
      expect(res.code).to eq('200')
      expect(JSON.parse(res.body)).to eq(
        {
          'acknowledged' => true,
          'shards_acknowledged' => true,
          'index' => index_name
        }
      )
    end
  end

  context '.delete' do
    before do
      url = Marqo::UrlHelpers.delete_index_endpoint(endpoint, index_name)
      stub_request(:delete, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          }
        ).to_return(status: 200, body: expected_response.to_json, headers: {})
    end

    let(:endpoint) { 'http://localhost:8882' }
    let(:index_name) { 'test' }
    let(:expected_response) do
      { acknowledged: true }
    end

    it 'returns ok' do
      res = Marqo::Index.delete(endpoint, index_name)
      expect(res.code).to eq('200')
    end
  end

  context '.refresh' do
    before do
      url = Marqo::UrlHelpers.refresh_endpoint(endpoint, index_name)
      stub_request(:post, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          }
        ).to_return(status: 200, body: expected_response.to_json, headers: {})
    end

    let(:endpoint) { 'http://localhost:8882' }
    let(:index_name) { 'test' }
    let(:expected_response) do
      {
        _shards: {
          total: 3,
          successful: 3,
          failed: 0
        }
      }
    end

    it 'returns ok' do
      res = Marqo::Index.refresh(endpoint, index_name)
      expect(res.code).to eq('200')
    end
  end

  context '.health' do
    before do
      url = Marqo::UrlHelpers.health_endpoint(endpoint, index_name)
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
        status: "green",
        backend: {
          status: "green",
          storage_is_available: true
        }
      }
    end

    it 'returns ok' do
      res = Marqo::Index.health(endpoint, index_name)
      expect(res.code).to eq('200')
    end
  end
end
