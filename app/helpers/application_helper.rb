module ApplicationHelper

  def title
    base_title = "Ruby on Rails 3 blog"
    if @title.nil?
      base_title
    else
      "#{@title}"
    end
  end
end
