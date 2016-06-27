json.array!(@images) do |image|
  json.extract! image, :id
  json.image_url image.url

  json.url api_v1_image_url(image, format: :json)
end
