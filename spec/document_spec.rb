# frozen_string_literal: true

require './lib/marqo/document'
require 'spec_helper'

RSpec.describe Marqo::Document do
  context '#create' do
    before do
      url = URI.join(endpoint, 'indexes/', "#{index_name}/", 'documents')
      stub_request(:post, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          }
        ).to_return(status: 200, body: expected_response.to_json, headers: {})
    end

    let(:endpoint) { 'http://localhost:8882' }
    let(:documents) do
      [
        {
          title: 'The Travels of Marco Polo',
          desc: 'A 13th-century travelogue describing the travels of Polo',
          genre: 'History'
        },
        {
          title: 'Extravehicular Mobility Unit (EMU)',
          desc: 'The EMU is a spacesuit that provides environmental protection',
          genre: 'Science',
          _id: 'hatkeo_08'
        }
      ]
    end
    let(:options) do
      {
        tensor_fields: %w[title desc]
      }
    end
    let(:index_name) { 'test' }
    let(:expected_response) do
      {
        errors: false,
        items: [
          {
            _id: '5aed93eb-3878-4f12-bc92-0fda01c7d23d',
            result: 'created',
            status: 201
          },
          {
            _id: 'hatkeo_08',
            result: 'updated',
            status: 200
          }
        ],
        processingTimeMs: 6,
        index_name: index_name
      }
    end

    it 'returns ok' do
      res = Marqo::Document.create(endpoint, index_name, documents, options)
      expect(res.code).to eq('200')
      expect(JSON.parse(res.body)['error']).to be_falsey
    end
  end

  context '#find' do
    let(:index_name) { 'test' }
    let(:endpoint) { 'http://localhost:8882' }
    let(:document_id) { 'hatkeo_08' }

    context 'when expose_facets is false' do
      before do
        url = URI.join(endpoint, 'indexes/', "#{index_name}/", 'documents/', document_id)
        stub_request(:get, url)
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
            }
          ).to_return(status: 200, body: expected_response.to_json, headers: {})
      end

      let(:options) do
        {
          expose_facets: false
        }
      end
      let(:expected_response) do
        {
          title: 'Extravehicular Mobility Unit (EMU)',
          desc: 'The EMU is a spacesuit that provides environmental protection',
          genre: 'Science',
          _id: 'hatkeo_08'
        }
      end

      it 'returns ok' do
        res = Marqo::Document.find(endpoint, index_name, document_id, options)
        expect(res.code).to eq('200')
        expect(JSON.parse(res.body)['title']).to eq('Extravehicular Mobility Unit (EMU)')
      end
    end

    context 'when expose_facets is true' do
      before do
        url = URI.join(endpoint, 'indexes/', "#{index_name}/", 'documents/', document_id)
        stub_request(:get, "#{url}?expose_facets=true")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
            }
          ).to_return(status: 200, body: expected_response.to_json, headers: {})
      end

      let(:options) do
        {
          expose_facets: true
        }
      end
      let(:expected_response) do
        {
          title: 'Extravehicular Mobility Unit (EMU)',
          desc: 'The EMU is a spacesuit that provides environmental protection',
          genre: 'Science',
          _id: 'hatkeo_08',
          _tensor_facets: [
            {
              title: 'Extravehicular Mobility Unit (EMU)',
              _embedding: [
                -0.06296932697296143,
                -0.028201380744576454,
                -0.04700359329581261
              ]
            },
            {
              desc: 'Extravehicular Mobility Unit (EMU)',
              _embedding: [
                -0.00356127112172544,
                0.003322685370221734,
                0.0234907828271389
              ]
            }
          ]
        }
      end

      it 'returns ok' do
        res = Marqo::Document.find(endpoint, index_name, document_id, options)
        expect(res.code).to eq('200')
        expect(JSON.parse(res.body)['_tensor_facets'].count).to eq(2)
      end
    end
  end

  context '#finds' do
    before do
      url = URI.join(endpoint, 'indexes/', "#{index_name}/", 'documents')
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
    let(:document_ids) { ['hatkeo_08'] }

    context 'when expose_facets is false' do
      let(:options) do
        {
          expose_facets: false
        }
      end
      let(:expected_response) do
        {
          results: [
            {
              _found: true,
              title: 'Extravehicular Mobility Unit (EMU)',
              desc: 'The EMU is a spacesuit that provides environmental protection',
              genre: 'Science',
              _id: 'hatkeo_08'
            }
          ]
        }
      end

      it 'returns ok' do
        res = Marqo::Document.finds(endpoint, index_name, document_ids, options)
        expect(res.code).to eq('200')
        expect(JSON.parse(res.body)['results'][0]['title']).to eq('Extravehicular Mobility Unit (EMU)')
      end
    end
  end
end
