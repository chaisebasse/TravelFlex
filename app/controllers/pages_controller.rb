require "open-uri"
require "nokogiri"

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
    Can you find me 5 destinations,
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
        })
    return response
  end



  # def scraping(destinations)
  #   response = []
  #   destinations.each do |destination|
  #     classe = ".lazy"
  #     region = destination["region"].parameterize
  #     region.strip!
  #     region = region.gsub!(/-/, '_') if region.include?("-")
  #     country = destination["pays"].parameterize
  #     country.strip!
  #     country = country.gsub!(/-/, '_') if country.include?("-")

  #     url = "https://www.routard.com/guide/code_dest/#{region}.htm"
  #     begin

  #       html_file = URI.open(url).read
  #       html_doc = Nokogiri::HTML.parse(html_file)

  #     rescue StandardError => e
  #       client = GoogleSearchResults.new(q: "site:#{website_domain} #{location}")
  #       search_results = client.get_hash
  #       result_url = search_results['organic_results'].first['link']
  #       html_doc = Nokogiri::HTML(URI.open(result_url))

  #       main_div = html_doc.css(".community").first
  #       target_photo = main_div.css(classe).first
  #       img_src = target_photo['src']

  #       p_tag_select = html_doc.search('.community p')
  #       if p_tag_select.css('.lieu-intro')
  #         p_tag = p_tag_select.html_doc.css('.lieu-intro').first
  #       else
  #         p_tag = p_tag_select.reject { |par| !par.css('.lieu-intro').nil? }.first
  #       end
  #     rescue AnotherError => e
  #     end


  #       html_file = URI.open(url).read
  #       html_doc = Nokogiri::HTML.parse(html_file)

  #       main_div = html_doc.css(".home-destination-media-img-wrapper").first
  #       target_photo = main_div.css(classe).first
  #       img_src = target_photo['src']

  #       div = html_doc.search('.home-dest-desc p')
  #       filtered_paragraphes = div.reject { |par| !par.at('strong').nil? }
  #       p_tag = filtered_paragraphes.first

  #     else
  #       url = "https://www.routard.com/guide/code_dest/#{country}.htm"
  #       html_file = URI.open(url).read
  #       html_doc = Nokogiri::HTML.parse(html_file)

  #       main_div = html_doc.css(".home-destination-media-img-wrapper").first
  #       target_photo = main_div.css(classe).first
  #       img_src = target_photo['src']

  #       div = html_doc.search('.home-dest-desc p')
  #       filtered_paragraphes = div.reject { |par| !par.at('strong').nil? }
  #       p_tag = filtered_paragraphes.first
  #     end

  #     text_before_br = p_tag.children.select { |node| node.name == 'text' }.first
  #     @text_content = text_before_br.text.strip

  #     destination["img_src"] = img_src
  #     destination["text_content"] = @text_content
  #     response << destination
  #   end

  #   # soluce quand pas de pays trouvé sur html_file
  #   return response
  # end




  def scraping(destinations)
    response = []
    destinations.each do |destination|
      classe = ".lazy"
      country = destination["pays"].parameterize
      country.strip!
      country = country.gsub!(/-/, '_') if country.include?("-")
      begin
        url = "https://www.routard.com/guide/code_dest/#{country}.htm"
        html_file = URI.open(url).read
        html_doc = Nokogiri::HTML.parse(html_file)
      rescue StandardError => e
        response << destination
      end
      photo_div = html_doc.css(".home-destination-media-img-wrapper").first
      target_photo = photo_div.css(classe).first
      img_src = target_photo['src']

      begin
        div = html_doc.search('.home-dest-desc p')
        filtered_paragraphes = div.reject { |par| !par.at('strong').nil? }
        p_tag = filtered_paragraphes.first
        text_before_br = p_tag.children.select { |node| node.name == 'text' }.first
        @text_content = text_before_br.text.strip
      rescue StandardError => e
        destination["img_src"] = img_src
        response << destination
      end
      destination["img_src"] = img_src
      destination["text_content"] = @text_content
      response << destination
    end
    return response
  end


  def dashboard
    if user_signed_in?
      @travels = current_user.travels
    else
      redirect_to new_user_session_path
    end
  end


  # def travel_params
  #   params.require(:travel).permit(:theme, :duration, :budget, :travelers, :starting_date)
  # end

  # def create_form_one
  #   @travel = Travel.new(travel_params)
  #   @travel.user = current_user
  #   @travel.save
  #   redirect_to destinations_path
  # end

  def search
    @travel = Travel.new
  end
end
