module ArticlesHelper
  # "Robert Huberdeau", or "Robert Huberdeau - <page title>" when the page sets one.
  def full_title(page_title = "")
    [ "Robert Huberdeau", page_title.presence ].compact.join(" - ")
  end

  def publish_date(article)
    (article.published_at || article.created_at).strftime("%b %-d, %Y")
  end

  # The editor's "Markdown help": each example is rendered with the real
  # markdown() helper next to its source, so the sheet always shows exactly
  # what the site supports.
  MARKDOWN_EXAMPLES = [
    [ "Headings", "## Section\n### Subsection" ],
    [ "Emphasis", "**bold**, _italic_, ~~struck~~" ],
    [ "Links", "[GitHub](https://github.com) or a bare https://example.com" ],
    [ "Images", "![Alt text](https://example.com/photo.jpg)" ],
    [ "Inline code", "Run `bin/rails db:migrate`" ],
    [ "Code block", "```ruby\ndef hello\n  puts \"hi\"\nend\n```" ],
    [ "Lists", "- one\n- two\n\n1. first\n2. second" ],
    [ "Task list", "- [x] done\n- [ ] to do" ],
    [ "Quote", "> Quoted text" ],
    [ "Table", "| Gem | Version |\n|-----|---------|\n| rails | 8.1 |" ],
    [ "Footnote", "A claim.[^1]\n\n[^1]: The source." ],
    [ "Emoji", ":tada: :rocket:" ],
    [ "Divider", "---" ]
  ].freeze
end
