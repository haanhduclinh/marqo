# Marqo

Ruby Driver for Marqo.
Supported Marqo version [1.2.0](https://docs.marqo.ai/1.2.0/) - https://docs.marqo.ai/1.2.0/


## Usage

```
client = Marqo::Client.new(endpoint, index_name)
```

### create index
```
options = {
    number_of_shards: 3,
    number_of_replicas: 0
}
client.create_index(index_name, options)
```

valid options - [ref](https://docs.marqo.ai/1.2.0/API-Reference/indexes/) 

```
{
  "index_defaults": {
      "treat_urls_and_pointers_as_images": false,
      "model": "hf/all_datasets_v4_MiniLM-L6",
      "normalize_embeddings": true,
      "text_preprocessing": {
          "split_length": 2,
          "split_overlap": 0,
          "split_method": "sentence"
      },
      "image_preprocessing": {
          "patch_method": null
      },
      "ann_parameters" : {
          "space_type": "cosinesimil",
          "parameters": {
              "ef_construction": 128,
              "m": 16
          }
      }
  },
  "number_of_shards": 3,
  "number_of_replicas": 0
}
```
### list_index
```
client.list
```

### delete_index
```
client.delete_index
```

### add_documents
```
documents = [
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

options = { tensor_fields: %w[title desc] }
client.add_documents(documents, options)
```

### find_doc
```
client.find_doc('hatkeo_08', { expose_facets: false })
```

### find_docs (does not support options yet - TODO)

```
client.find_doc(['hatkeo_08', 'another_ids'])
```

### delete_docs

```
client.delete_docs(['hatkeo_08', 'another_ids'])
```

### search
```
query = 'what is the best outfit to wear on the moon?'
default_options = {
    limit: 20,
    offset: 0,
    showHighlights: true,
    searchMethod: Marqo::Search::SEARCH_METHOD_TENSOR,
    attributesToRetrieve: ['*'],
    image_download_headers: {}
}
client.search(query, default_options)
```

- search_options - [ref](https://docs.marqo.ai/1.2.0/API-Reference/search/)

# possible options
* filter - https://docs.marqo.ai/1.2.0/API-Reference/search/#filter
* searchableAttributes - https://docs.marqo.ai/1.2.0/API-Reference/search/#searchable-attributes
* reRanker - https://docs.marqo.ai/1.2.0/API-Reference/search/#reranker
* boost - https://docs.marqo.ai/1.2.0/API-Reference/search/#boost
* context - https://docs.marqo.ai/1.2.0/API-Reference/search/#context
* score_modifiers - https://docs.marqo.ai/1.2.0/API-Reference/search/#score-modifiers
* modelAuth - https://docs.marqo.ai/1.2.0/API-Reference/search/#model-auth


## Contributing

- TODO: add support for 
+ mapping. There document seems not clear - [ref](https://docs.marqo.ai/1.2.0/API-Reference/mappings/)
+ bulk - [ref](https://docs.marqo.ai/1.2.0/API-Reference/bulk/)

make sure follow rubocop and add test for it
```
rake check
rake test
```

- Bug reports and pull requests are welcome on GitHub at https://github.com/haanhduclinh/marqo.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
