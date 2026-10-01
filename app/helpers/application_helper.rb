module ApplicationHelper
  # GitHub-flavoured Markdown. Raw HTML in an article is dropped, not
  # rendered, so a body can't inject scripts; fenced code blocks are
  # highlighted with inline styles, so no stylesheet has to match a theme.
  MARKDOWN_PLUGINS = { syntax_highlighter: { theme: "InspiredGitHub" } }.freeze

  def markdown(text)
    Commonmarker.to_html(text.to_s, plugins: MARKDOWN_PLUGINS).html_safe
  end
end
