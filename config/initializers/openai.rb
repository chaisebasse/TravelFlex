OpenAI.configure do |config|
   config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
   # config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID") # Optional.
   config.uri_base = "https://oai.hconeai.com/" # Optional
   config.request_timeout = 120 # Optional possibilité de changer pour réduire au temps nécessaire pour la requête
end
