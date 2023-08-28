# frozen_string_literal: true

require './lib/marqo/index'
require 'spec_helper'

RSpec.describe Marqo::Index do
  context '#list' do
    before do
      url = URI.join(endpoint, 'indexes')
      stub_request(:get, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          }
        ).to_return(status: 200, body: { 'results' => [{ 'index_name' => 'test' }] }.to_json, headers: {})
    end

    let(:endpoint) { 'http://localhost:8882' }

    it 'returns ok' do
      res = Marqo::Index.list(endpoint)
      expect(res.code).to eq('200')
    end
  end

  context '#create' do
    before do
      url = URI.join(endpoint, 'indexes/', index_name)
      stub_request(:post, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          }
        ).to_return(status: 200, body: {
          'acknowledged' => true,
          'shards_acknowledged' => true,
          'index' => index_name
        }.to_json, headers: {})
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

  context '#delete' do
    before do
      url = URI.join(endpoint, 'indexes/', index_name)
      stub_request(:delete, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          }
        ).to_return(status: 200, body: { acknowledged: true }.to_json, headers: {})
    end

    let(:endpoint) { 'http://localhost:8882' }
    let(:index_name) { 'test' }

    it 'returns ok' do
      res = Marqo::Index.delete(endpoint, index_name)
      expect(res.code).to eq('200')
    end
  end
end
