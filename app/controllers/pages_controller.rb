class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end


def search_results
  client = OpenAI::Client.new
  response = client.completions(
    parameters: {
      model: "text-davinci-003",
      prompt: "Give me a JSON of 5 destinations, budget #{params[budget]}for a #{params[type_of_travelers]}
      #{params[type_of_destination]} #{params[duration]} max 10 token / x:{country:, city:, lat:, long:}",
      max_tokens: 200
  })
  choices = response['choices']
  @destinations_array = choices[0]['text']
end
end
