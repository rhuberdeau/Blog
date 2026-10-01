# schema_date is part of every entry id (tag:host,2010:Article/1); readers treat
# ids as permanent, so never change it.
atom_feed(root_url: root_url, schema_date: "2010") do |feed|
  feed.title "Robert Huberdeau"
  feed.updated @articles.first&.published_at || Time.current

  @articles.each do |article|
    feed.entry(article, published: article.published_at, updated: article.updated_at) do |entry|
      entry.title article.title
      entry.summary article.summary
      entry.content markdown(article.body), type: "html"
      entry.author { |author| author.name "Robert Huberdeau" }
      article.tags.each { |tag| entry.category term: tag.name }
    end
  end
end
