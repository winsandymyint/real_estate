json.array!(@posts) do |post|
  json.extract! post, :id, :heading, :body, :price, :neighborhood, :external_url, :timestamp, bedrooms, bathrooms, cats, dogs, w_di_in_unit, street_parking
  json.url post_url(post, format: :json)
end
