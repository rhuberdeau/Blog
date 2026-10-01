# Development data: the author and a few articles so every public page has
# something to show. Safe to run more than once. In production, set
# ADMIN_EMAIL / ADMIN_PASSWORD (or create the user from the console).
author = User.find_or_initialize_by(email_address: ENV.fetch("ADMIN_EMAIL", "admin@example.com"))
if author.new_record?
  author.password = ENV.fetch("ADMIN_PASSWORD") { Rails.env.production? ? raise("Set ADMIN_PASSWORD") : "password123" }
  author.save!
end

return if Rails.env.production?

[
  [ "Hello again", "The blog is back, running in Docker.", "ruby,docker", true ],
  [ "Upgrading Rails one step at a time", "Notes on moving an old app forward.", "ruby,rails", true ],
  [ "A draft nobody sees", "Still being written.", "drafts", false ]
].each do |title, summary, tags, published|
  article = author.articles.find_or_initialize_by(title: title)
  article.summary   = summary
  article.body      = "#{summary}\n\n```ruby\nputs 'hello'\n```\n"
  article.tag_names = tags
  article.published = published
  article.published_on ||= Time.current if published
  article.save!
end
