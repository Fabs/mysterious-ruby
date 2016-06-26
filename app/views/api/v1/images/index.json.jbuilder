json.array!(@images) do |image|
  json.extract! image, :id, :url, :references
  json.url image_url(image, format: :json)
end
