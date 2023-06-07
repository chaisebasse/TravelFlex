require "open-uri"
require "nokogiri"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home destinations search]

  def home
    @travels = Travel.all

    classe = ".lazy"
    country = "liechtenstein"
    url = "https://www.routard.com/guide/code_dest/#{country}.htm"
    html_file = URI.open(url).read

    html_doc = Nokogiri::HTML.parse(html_file)

    photo_div = html_doc.css(".home-destination-media-img-wrapper").first
    target_photo = photo_div.css(classe).first
    @img_src = target_photo['src']

    outer_div = html_doc.css('.home-dest-desc').first
    nested_div = outer_div.css('div[style]').first
    p_tag = nested_div.css('p')[0]
    text_before_br = p_tag.children.select { |node| node.name == 'text' }.first
    @text_content = text_before_br.text.strip
  end


def search_results
  client = OpenAI::Client.new
  response = client.completions(
    parameters: {
      model: "text-davinci-003",
      prompt: 'Give me an array of 5 destinations, budget #{params[:budget]} for a
      #{params[:type_of_travelers]} #{params[:type_of_destination]} #{params[:duration]} max 10 token / [{"country":, "city":, "lat":, "long":}]',
      max_tokens: 350
  })
  choices = response['choices']
  destinations = response['choices'][0]['text']
  @destinations_array = JSON.parse(destinations)
  redirect_to destinations_path(result:@destinations_array)
end

 def dashboard
    if user_signed_in?
      @travels = current_user.travels
    else
      redirect_to new_user_session_path
    end
  end

  def destinations
    end


  # def search
  #   @travel = Travel.new
  # end

  # def create_form_one
  #   @travel = Travel.new(travel_params)
  #   @travel.user = current_user
  #   @travel.save
  #   redirect_to destinations_path
  # end

  # private

  # def travel_params
  #   params.require(:travel).permit(:theme, :duration, :budget, :travelers, :starting_date)
  # end
end
