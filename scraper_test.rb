def scraping(destinations)
  response = []
  destinations.each do |destination|
    classe = ".lazy"
    region = destination["region"].parameterize
    region.strip!
    region = region.gsub!(/-/, '_') if region.include?("-")
    country = destination["country"].parameterize
    country.strip!
    country = country.gsub!(/-/, '_') if country.include?("-")

    url = "https://www.routard.com/guide/code_dest/#{region}.htm"
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML.parse(html_file)

    if url.nil? == false
      html_file = URI.open(url).read
      html_doc = Nokogiri::HTML.parse(html_file)

      main_div = html_doc.css(".home-destination-media-img-wrapper").first
      target_photo = main_div.css(classe).first
      img_src = target_photo['src']

      div = html_doc.search('.home-dest-desc p')
      filtered_paragraphes = div.reject { |par| !par.at('strong').nil? }
      p_tag = filtered_paragraphes.first
    elsif url.nil?
      client = GoogleSearchResults.new(q: "site:#{website_domain} #{location}")
      search_results = client.get_hash
      result_url = search_results['organic_results'].first['link']
      html_doc = Nokogiri::HTML(URI.open(result_url))

      main_div = html_doc.css(".community").first
      target_photo = main_div.css(classe).first
      img_src = target_photo['src']

      p_tag_select = html_doc.search('.community p')
      if p_tag_select.css('.lieu-intro')
        p_tag = p_tag_select.html_doc.css('.lieu-intro').first
      else
        p_tag = p_tag_select.reject { |par| !par.css('.lieu-intro').nil? }.first
      end
    else
      url = "https://www.routard.com/guide/code_dest/#{country}.htm"
      html_file = URI.open(url).read
      html_doc = Nokogiri::HTML.parse(html_file)

      main_div = html_doc.css(".home-destination-media-img-wrapper").first
      target_photo = main_div.css(classe).first
      img_src = target_photo['src']

      div = html_doc.search('.home-dest-desc p')
      filtered_paragraphes = div.reject { |par| !par.at('strong').nil? }
      p_tag = filtered_paragraphes.first
    end

    text_before_br = p_tag.children.select { |node| node.name == 'text' }.first
    @text_content = text_before_br.text.strip

    destination["img_src"] = img_src
    destination["text_content"] = @text_content
    response << destination
  end

  # soluce quand pas de pays trouvé sur html_file
  return response
end
