module Ai
  module Tasks
    # Suggests titles, a summary and tags for the current draft.
    class Metadata < Base
      class << self
        def max_tokens = 4_000

        def system_prompt
          <<~PROMPT
            You suggest metadata for a draft post on Robert Huberdeau's personal blog
            about software engineering. Match the author's plain, direct voice; no
            clickbait.
            - titles: 5 options, each at most 70 characters.
            - summary: one sentence, at most 160 characters, shown under the title.
            - tags: 2 to 5 short lowercase tags. Prefer tags from the existing list when
              they fit; add a new one only when none does.
          PROMPT
        end

        def user_prompt(input)
          existing = Array(input["existing_tags"]).join(", ").presence || "none"
          "Existing tags: #{existing}\n\n#{article_xml(input)}"
        end

        def schema
          object(titles: strings, summary: { type: "string" }, tags: strings)
        end

        def fake_result(_input)
          { "titles" => [ "A suggested title", "Another title" ], "summary" => "A suggested summary.",
            "tags" => %w[ruby rails] }
        end
      end
    end
  end
end
