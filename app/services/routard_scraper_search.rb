# require "open-uri"
# require "nokogiri"
# require 'google_search_results'

# class RoutardScraperSearch
#   def initialize(region, country)
#     @region = region
#     @country = country
#     GoogleSearch.api_key = ENV['GOOGLESEARCH_API_KEY']
#   end

#   def call
#     begin
#       client = GoogleSearch.new(q: "site:routard.com #{@region}")
#       search_results = client.get_hash
#       title_regex = /\AVisiter \D+(\D+)*, Voyage \D+/
#       result = search_results[:organic_results].find { |r| r[:title].match(title_regex) }
#       result_url = result[:link] if result
#       html_doc = Nokogiri::HTML(URI.open(result_url))

#       main_div = html_doc.css(".community").first
#       target_photo = main_div.css(".lazy").first
#       img_src = target_photo['src']

#       p_tag_select = main_div.search('p')

#       if p_tag_select.at_css('.lieu-intro').text.present?
#         p_tag = p_tag_select.at_css('.lieu-intro').text.strip
#       else
#         p_tag = p_tag_select.map(&:text).find(&:present?).text.strip
#       end
#       return [img_src, p_tag.scan(/[^.]*?(?:\.+|\u2026)(?![.])/)]
#     rescue => e
#       RoutardScraperExtra.new(@region, @country).call
#     end
#   end
# end
