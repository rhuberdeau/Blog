module ArticlesHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = "")
    base_title = "Robert Huberdeau"
    if page_title.empty?
        base_title
    else
        "#{base_title} - #{page_title}"
    end
  end

  def publish_date(article)
    (article.published_at || article.created_at).strftime("%b %-d, %Y")
  end
end
