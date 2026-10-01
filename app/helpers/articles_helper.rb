module ArticlesHelper
  # "Robert Huberdeau", or "Robert Huberdeau - <page title>" when the page sets one.
  def full_title(page_title = "")
    [ "Robert Huberdeau", page_title.presence ].compact.join(" - ")
  end

  def publish_date(article)
    (article.published_at || article.created_at).strftime("%b %-d, %Y")
  end
end
