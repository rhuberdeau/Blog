# Runs on `db:seed`, and also from `db:prepare` whenever it creates a
# database, which includes a production container's first boot. So it must
# never fail: without credentials in production it says what to do instead.
email    = ENV.fetch("ADMIN_EMAIL", "admin@example.com")
password = ENV["ADMIN_PASSWORD"].presence || ("password123" unless Rails.env.production?)

author = User.find_by(email_address: email)
if author.nil? && password
  author = User.create!(email_address: email, password: password)
elsif author.nil?
  puts "No author created: set ADMIN_EMAIL and ADMIN_PASSWORD and run bin/rails db:seed (see README)."
end

# Sample articles for development only.
return if Rails.env.production? || author.nil?

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
  article.save!
end
