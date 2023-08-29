RSpec.describe Marqo::Client do
  let(:index_name) { 'test' }
  let(:endpoint) { 'http://localhost:8882' }
  subject { Marqo::Client.new(endpoint, index_name) }

  context '#create_index' do
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

    let(:options) do
      {
        index_defaults: {
          model: 'hf/all_datasets_v4_MiniLM-L6'
        }
      }
    end
    let(:expected_response) do
      {
        acknowledged: true,
        shards_acknowledged: true,
        index: index_name
      }
    end

    it 'returns ok' do
      res = subject.create_index(index_name)
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

  context '#list_index' do
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
      res = subject.list_index
      expect(res.code).to eq('200')
    end
  end

  context '#delete_index' do
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

    let(:expected_response) do
      { acknowledged: true }
    end

    it 'returns ok' do
      res = subject.delete_index
      expect(res.code).to eq('200')
    end
  end

  context '#add_documents' do
    before do
      url = Marqo::UrlHelpers.base_document_endpoint(endpoint, index_name)
      stub_request(:post, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          }
        ).to_return(status: 200, body: expected_response.to_json, headers: {})
    end

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
      res = subject.add_documents(documents, options)
      expect(res.code).to eq('200')
      expect(JSON.parse(res.body)['error']).to be_falsey
    end
  end

  context '#find_doc' do
    let(:document_id) { 'hatkeo_08' }

    context 'when expose_facets is false' do
      before do
        url = Marqo::UrlHelpers.find_document_endpoint(endpoint, index_name, document_id)
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
        res = subject.find_doc(document_id, options)
        expect(res.code).to eq('200')
        expect(JSON.parse(res.body)['title']).to eq('Extravehicular Mobility Unit (EMU)')
      end
    end

    context 'when expose_facets is true' do
      before do
        url = Marqo::UrlHelpers.find_document_endpoint(endpoint, index_name, document_id)
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
        res = subject.find_doc(document_id, options)
        expect(res.code).to eq('200')
        expect(JSON.parse(res.body)['_tensor_facets'].count).to eq(2)
      end
    end
  end

  context '#find_docs' do
    before do
      url = Marqo::UrlHelpers.base_document_endpoint(endpoint, index_name)
      stub_request(:get, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          }
        ).to_return(status: 200, body: expected_response.to_json, headers: {})
    end

    let(:document_ids) { ['hatkeo_08'] }
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
      res = subject.find_docs(document_ids)
      expect(res.code).to eq('200')
      expect(JSON.parse(res.body)['results'][0]['title']).to eq('Extravehicular Mobility Unit (EMU)')
    end
  end

  context '#delete_docs' do
    before do
      url = Marqo::UrlHelpers.delete_document_endpoint(endpoint, index_name)
      stub_request(:post, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          },
          body: document_ids.to_json
        ).to_return(status: 200, body: expected_response.to_json, headers: {})
    end

    let(:document_ids) { ['hatkeo_08'] }
    let(:expected_response) do
      {
        index_name: index_name,
        status: "succeeded",
        type: "documentDeletion",
        details: {
          receivedDocumentIds: 1,
          deletedDocuments: 1
        },
        duration: "PT0.084367S",
        startedAt: "2022-09-01T05:11:31.790986Z",
        finishedAt: "2022-09-01T05:11:31.875353Z"
      }
    end

    it 'returns ok' do
      res = subject.delete_docs(document_ids)
      expect(res.code).to eq('200')
      expect(JSON.parse(res.body)['status']).to eq('succeeded')
    end
  end

  context '#search' do
    before do
      url = Marqo::UrlHelpers.search_endpoint(endpoint, index_name)
      stub_request(:post, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          }
        ).to_return(status: 200, body: expected_response.to_json, headers: {})
    end

    let(:query) { 'what is the best outfit to wear on the moon?' }
    let(:expected_response) do
      { "hits" =>
        [{ "genre" => "Science",
           "title" => "Extravehicular Mobility Unit (EMU)",
           "desc" => "The EMU is a spacesuit that provides environmental protection",
           "_id" => "hatkeo_08",
           "_highlights" => { "desc" => "The EMU is a spacesuit that provides environmental protection" },
           "_score" => 0.6133641 },
         { "genre" => "History",
           "title" => "The Travels of Marco Polo",
           "desc" => "A 13th-century travelogue describing the travels of Polo",
           "_id" => "d6ec25e5-d0bb-4caa-a13a-866c35ceb8d9",
           "_highlights" => { "title" => "The Travels of Marco Polo" },
           "_score" => 0.6023733 }],
        "query" => "what is the best outfit to wear on the moon?",
        "limit" => 20,
        "offset" => 0,
        "processingTimeMs" => 270 }
    end

    it 'returns ok' do
      res = subject.search(query)
      expect(res.code).to eq('200')
      expect(JSON.parse(res.body)['hits'].count).to eq(2)
    end
  end

  context '#device_cpu' do
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

    let(:expected_response) do
      {
        cpu_usage_percent: "1.0 %",
        memory_used_percent: "70.0 %",
        memory_used_gb: "11.2"
      }
    end

    it 'returns ok' do
      res = subject.device_cpu
      expect(res.code).to eq('200')
    end
  end

  context '#device_cuda' do
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
      res = subject.device_cuda
      expect(res.code).to eq('200')
    end
  end
end
