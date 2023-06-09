require "open-uri"
require "nokogiri"

class RoutardScraperCountry
  def initialize(region, country)
    @region = region
    @country = country
  end

  def call
    # scraping code
    url = "https://www.routard.com/guide/code_dest/#{@country}.htm"
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML.parse(html_file)

    main_div = html_doc.css(".home-destination-media-img-wrapper").first
    target_photo = main_div.css(".lazy").first
    img_src = target_photo['src']

    div = html_doc.search('.home-dest-desc p')
    filtered_paragraphes = div.reject { |par| !par.at('strong').nil? }
    text_before_first_br = filtered_paragraphes.first.text
    p_tag = text_before_first_br
    return [img_src, p_tag.scan(/[^.]*?(?:\.+|\u2026)(?![.])/)]
  end
end
