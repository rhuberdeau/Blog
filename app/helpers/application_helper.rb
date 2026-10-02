module ApplicationHelper
  # GitHub-flavoured Markdown. Raw HTML in an article is dropped, not
  # rendered, so a body can't inject scripts. Fenced code blocks are
  # highlighted with TextMate scope classes (theme ""), which
  # application.css colours for light and dark mode. Footnotes are off in
  # commonmarker by default (a "[^1]" then renders as a broken link), so
  # they're switched on. The editor's "Markdown help" renders its examples
  # through this same method.
  MARKDOWN_OPTIONS = { extension: { footnotes: true } }.freeze
  MARKDOWN_PLUGINS = { syntax_highlighter: { theme: "" } }.freeze

  def markdown(text)
    # nil.to_s is US-ASCII, which commonmarker rejects (a new article has no body yet).
    Commonmarker.to_html(text.to_s.encode(Encoding::UTF_8), options: MARKDOWN_OPTIONS, plugins: MARKDOWN_PLUGINS).html_safe
  end
end
