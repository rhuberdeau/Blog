desc "Populate published_on for articles that do not have it"
task add_published_dates: :environment do
  articles = Article.where(published_on: nil)
  puts "Updating #{articles.length} articles"
  articles.each {|a| a.update_attribute(:published_on, a.created_at)}
end
