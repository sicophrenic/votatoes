json.array!(@plantations) do |plantation|
  json.extract! plantation, 
  json.url plantation_url(plantation, format: :json)
end
