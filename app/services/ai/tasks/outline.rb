module Ai
  module Tasks
    # Builds a post outline from a topic, optionally grounded in saved research.
    class Outline < Base
      class << self
        def system_prompt
          <<~PROMPT
            You help Robert Huberdeau, a senior software engineer, plan posts for his
            personal blog. Build an outline the author will write from, in his plain,
            direct voice: a clear point of view, concrete examples, no filler sections.
            - title_options: 3 to 5 titles, each at most 70 characters.
            - summary: one sentence, at most 160 characters.
            - sections: 4 to 8 sections in order, each with a heading and 2 to 5 short
              bullet points of what to cover. Where research is provided, ground the
              points in it.
          PROMPT
        end

        def user_prompt(input)
          parts = [ "Outline a post about: #{input["topic"]}" ]
          parts << "Author's notes:\n#{input["notes"]}" if input["notes"].present?
          if (research = input["research"]).present?
            points = Array(research["key_points"]).map { |point| "- #{point}" }.join("\n")
            parts << "Research notes:\n#{research["summary"]}\n\nKey points:\n#{points}"
          end
          parts.join("\n\n")
        end

        def schema
          section = object(heading: { type: "string" }, points: strings)
          object(title_options: strings, summary: { type: "string" },
                 sections: { type: "array", items: section })
        end

        def fake_result(input)
          {
            "title_options" => [ "Thinking about #{input["topic"]}".first(70) ],
            "summary" => "What I learned.",
            "sections" => [ { "heading" => "Why it matters", "points" => [ "The problem", "Who it affects" ] },
                            { "heading" => "What to do", "points" => [ "The approach" ] } ]
          }
        end
      end
    end
  end
end
