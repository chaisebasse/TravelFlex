require "open-uri"
require "nokogiri"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

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

  def dashboard
    if user_signed_in?
      @travels = current_user.travels
      @travels = current_user.travels
    else
      redirect_to new_user_session_path
    end
  end
end
