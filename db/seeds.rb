# Development data: one admin and a few articles so every public page has
# something to show. Safe to run more than once.
admin = User.find_or_initialize_by(email: "admin@example.com")
admin.password = admin.password_confirmation = "password123"
admin.admin = true
admin.save!

[
  [ "Hello again", "The blog is back, running in Docker.", "ruby,docker", true ],
  [ "Upgrading Rails one step at a time", "Notes on moving an old app forward.", "ruby,rails", true ],
  [ "A draft nobody sees", "Still being written.", "drafts", false ]
].each do |title, summary, tags, published|
  article = admin.articles.find_or_initialize_by(title: title)
  article.summary   = summary
  article.body      = "#{summary}\n\n```ruby\nputs 'hello'\n```\n"
  article.tag_names = tags
  article.published = published
  article.published_on ||= Time.current if published
  article.save!
end
