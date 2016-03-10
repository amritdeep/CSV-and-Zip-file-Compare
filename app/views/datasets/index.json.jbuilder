json.array!(@datasets) do |dataset|
  json.extract! dataset, :id, :batch
  json.url dataset_url(dataset, format: :json)
end
