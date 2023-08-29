# frozen_string_literal: true

RSpec.describe Marqo::Search do
  context '.run' do
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
    let(:endpoint) { 'http://localhost:8882' }
    let(:index_name) { 'test' }
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
      res = Marqo::Search.run(endpoint, index_name, query)
      expect(res.code).to eq('200')
      expect(JSON.parse(res.body)['hits'].count).to eq(2)
    end
  end
end
