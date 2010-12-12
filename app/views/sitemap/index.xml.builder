xml.urlset do
  for a in @articles
    xml.url do
      xml.loc("http://www.roberthuberdeau.com", (url_for(a)))
      xml.changefreq("weekly")
      xml.priority("0.7")
      if a.updated_at.nil?
        xml.lastmod(a.created_at.strftime("%Y-%m-%d"))
      else
      	xml.lastmod(a.updated_at.strftime("%Y-%m-%d"))
      end
    end
  end
end