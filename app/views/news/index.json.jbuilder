json.array!(@news) do |news|
  json.extract! news, :id, :title, :teaser, :body
  json.url news_url(news, format: :json)
end
