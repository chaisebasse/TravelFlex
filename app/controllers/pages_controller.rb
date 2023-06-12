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
    client = OpenAI::Client.new
    prompt_completion = "J'aimerais recevoir une chaîne JSON valide écrite en
     français de 5 destinations depuis Paris
    (hors France et royaume-uni) , budget #{params["travel"][:budget]} trajet inclus,
     pour un voyage en #{params["travel"][:type_of_travelers]},
    #{params["travel"][:type_of_destination]}, pour une durée de #{params["travel"][:duration]} jours / [{\"pays\":, \"region\":, \"lat\":, \"long\":},..]"
    querryOpenAi(prompt_completion)
    begin
      destinations = response['choices'][0]['text']
      destinations_cleaned = destinations.gsub(/^\s*- /, '')
      destinations_cleaned2 = destinations_cleaned.gsub(/–/, '-')
      destinations_array = JSON.parse(destinations_cleaned2)
      final_array = scraping(destinations_array)
      redirect_to destinations_path(result:final_array)
    rescue StandardError =>
      querryOpenAi(prompt_completion)
      destinations = response['choices'][0]['text']
      destinations_cleaned = destinations.gsub(/^\s*- /, '')
      destinations_cleaned2 = destinations_cleaned.gsub(/–/, '-')
      destinations_array = JSON.parse(destinations_cleaned2)
      final_array = scraping(destinations_array)
      redirect_to destinations_path(result:final_array)
    end
  end

  def destinations
  end

  def querryOpenAi(prompt_completion)
    response = client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: prompt_completion,
        max_tokens: 400
        })
        return response

  end


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


  def search
    @travel = Travel.new
  end

end
