require "open-uri"
require "nokogiri"
require 'google_search_results'

class RoutardScraperExtra
  def initialize(region, country)
    @region = region
    @country = country
    GoogleSearch.api_key = "d44a78a8bdb572f6d2c57e02852349329270bf834d8b95cbe23eb282a1d3b459"
  end

  def call
    begin
      client = GoogleSearch.new(q: "site:routard.com #{@region}")
      search_results = client.get_hash
      title_regex = %r{https://www.routard.com/\D*voyage\D*/.*.htm[l]?}
      result = search_results[:organic_results].find { |r| r[:link].match(title_regex) }
      result_url = result[:link] if result

      html_doc = Nokogiri::HTML(URI.open(result_url))
      main_div = html_doc.css(".article-mag.reportage").first
      target_photo = main_div.css(".lazy").first
      img_src = target_photo['src']

      p_tag_select = main_div.search('p')
      if p_tag_select.at_css('.mag-content').text.present?
        p_tag = p_tag_select.at_css('.mag-content')
      else
        p_tag = p_tag_select.map(&:text).find(&:present?)
      end
      return [img_src, p_tag.scan(/[^.]*?(?:\.+|\u2026)(?![.])/)]
    rescue => e
      RoutardScraperCountry.new(@region, @country).call
    end
  end
end
