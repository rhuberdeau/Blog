module ApplicationHelper
  # GitHub-flavoured Markdown. Raw HTML in an article is dropped, not
  # rendered, so a body can't inject scripts. Fenced code blocks are
  # highlighted with TextMate scope classes (theme ""), which
  # application.css colours for light and dark mode.
  MARKDOWN_PLUGINS = { syntax_highlighter: { theme: "" } }.freeze

  def markdown(text)
    Commonmarker.to_html(text.to_s, plugins: MARKDOWN_PLUGINS).html_safe
  end
end
