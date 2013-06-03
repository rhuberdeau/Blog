class AddCachedSlugValuesToArticles < ActiveRecord::Migration
  def change
  	a = Article.all
  	a.each do |a|
  	  a.cached_slug = "#{a.id}-#{a.title.gsub(/[^a-z0-9]+/i, '-')}".downcase
  	  a.save
  	end
  end
end
