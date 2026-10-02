module Ai
  # Turns a finished outline (and the research behind it, if any) into a new
  # draft article: headings and bullets to write from, plus the sources as
  # footnote-style references.
  class OutlineDraft
    def initialize(ai_request, author:)
      @ai_request = ai_request
      @outline = ai_request.result
      @author = author
    end

    def create!
      @author.articles.create!(
        title: unique_title,
        summary: @outline["summary"].presence || "Summary to write.",
        body: body,
        published: false
      )
    end

    private
      def unique_title
        base = Array(@outline["title_options"]).first.presence || @ai_request.subject
        base = base.to_s.first(70)
        return base unless Article.where("LOWER(title) = ?", base.downcase).exists?

        (2..99).each do |n|
          candidate = "#{base.first(70 - " (#{n})".length)} (#{n})"
          return candidate unless Article.where("LOWER(title) = ?", candidate.downcase).exists?
        end
      end

      def body
        sections = Array(@outline["sections"]).map do |section|
          points = Array(section["points"]).map { |point| "- #{point}" }.join("\n")
          "## #{section["heading"]}\n\n#{points}"
        end
        [ *sections, sources ].compact.join("\n\n") + "\n"
      end

      def sources
        list = Array(@ai_request.input.dig("research", "sources"))
        return if list.empty?

        "## Sources\n\n" + list.map { |source| "- [#{source["title"]}](#{source["url"]}): #{source["supports"]}" }.join("\n")
      end
  end
end
