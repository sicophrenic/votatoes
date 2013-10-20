json.array!(@votatos) do |votato|
  json.extract! votato, 
  json.url votato_url(votato, format: :json)
end
