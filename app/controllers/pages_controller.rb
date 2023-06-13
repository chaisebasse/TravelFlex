require "open-uri"
require "nokogiri"
require "google_search_results"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home destinations search]
  # classe = ".lazy"
  # country = "paris"
  # url = "https://www.routard.com/guide/code_dest/#{country}.htm"
  # html_file = URI.open(url).read

  def search_results
    session[:query] = params
    prompt_completion =
      "I am giving you a length of stay, a season , a type of travel and an average budget.

    Can you find me 5 destinations excluding France and Royaume-Uni,
    present those result in JSON that can be parsed in ruby (all the keys and values should be in double quotes).
    Each hash composing this array should be presented as followed :
    {
    pays:,
    region:,
    lat:,
    long:}

    Average Budget (including price for the travel): #{params['travel'][:budget]}
    Type of travelers : #{params['travel'][:type_of_travelers]}
    Type of destination : #{params['travel'][:type_of_destination]}
    Length of stay :  #{params['travel'][:duration]}
    Season: #{params['travel'][:saison]}

    The destinations should be coherent in terms of distance regarding the duration of the stay.
    Give you responses in French."

    response = querryOpenAi(prompt_completion)
    begin
      destinations = response['choices'][0]['text']
      destinations_cleaned = destinations.gsub(/^\s*- /, '')
      destinations_cleaned2 = destinations_cleaned.gsub(/–/, '-')
      destinations_array = JSON.parse(destinations_cleaned2)
      final_array = scraping(destinations_array)


      redirect_to destinations_path(result: final_array)
    rescue StandardError => e
      response = querryOpenAi(prompt_completion)
      destinations = response['choices'][0]['text']
      destinations_cleaned = destinations.gsub(/^\s*- /, '')
      destinations_cleaned2 = destinations_cleaned.gsub(/–/, '-')
      destinations_array = JSON.parse(destinations_cleaned2)
      final_array = scraping(destinations_array)
      redirect_to destinations_path(result: final_array)
    end
  end

  def destinations
  end

  def querryOpenAi(prompt_completion)
    client = OpenAI::Client.new
    response = client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: prompt_completion,
        max_tokens: 400
      }
    )
    return response
  end

  def scraping(destinations)
    response = []
    destinations.each do |destination|
      region = destination["region"].parameterize
      region.strip!
      region = region.gsub!(/-/, '_') if region.include?("-")
      country = destination["pays"].parameterize
      country.strip!
      country = country.gsub!(/-/, '_') if country.include?("-")

      scraper = RoutardScraper.new(region, country).call

      destination["img_src"] = scraper[0]
      destination["text_content"] = scraper[1]

      response << destination
    end

    # soluce quand pas de pays trouvé sur html_file
    return response
  end

  def dashboard
    if user_signed_in?
      @travels = current_user.travels
    else
      redirect_to new_user_session_path
    end
  end


  def search
    @travel = Travel.new
  end
end
