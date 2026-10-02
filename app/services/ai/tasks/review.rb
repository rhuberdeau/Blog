module Ai
  module Tasks
    # Reads a draft before publishing and lists specific problems, each tied
    # to an exact quote so the editor can apply the fix in place.
    class Review < Base
      CATEGORIES = %w[spelling grammar clarity structure fact-check tone].freeze

      class << self
        def system_prompt
          <<~PROMPT
            You are a careful copy editor reviewing a draft post for Robert Huberdeau's
            personal blog about software engineering. The body is Markdown.

            Find real problems only: spelling, grammar and punctuation; unclear or
            unfinished sentences; structure (an argument that jumps, a missing
            conclusion); factual claims a reader might dispute, which the author should
            verify; and tone that undercuts the author's point. Keep the author's voice:
            don't rewrite for style, don't pad, and don't flag Markdown syntax, code
            blocks, URLs or heading formatting.

            For each finding:
            - quote: copy the problematic text from the body EXACTLY as written,
              character for character, as short as possible while still unique in the
              body (a phrase or one sentence, never a whole paragraph).
            - suggestion: the replacement text for exactly that quote, ready to paste.
              For fact-check and structure findings, describe what to do instead.
            - explanation: one short sentence on why.
            At most 25 findings, most important first. If the draft is clean, return
            no findings and say so in the overall note.
          PROMPT
        end

        def user_prompt(input)
          "Review this draft:\n\n#{article_xml(input)}"
        end

        def schema
          object(
            overall: { type: "string", description: "One or two sentences on the draft as a whole." },
            findings: {
              type: "array",
              items: object(
                category: { type: "string", enum: CATEGORIES },
                quote: { type: "string" },
                suggestion: { type: "string" },
                explanation: { type: "string" }
              )
            }
          )
        end

        def fake_result(input)
          quote = input["body"].to_s[/\S+(?:\s+\S+){0,2}/].to_s
          {
            "overall" => "Reads well; one wording fix.",
            "findings" => [
              { "category" => "grammar", "quote" => quote, "suggestion" => "#{quote} (fixed)",
                "explanation" => "Example finding from the test client." },
              { "category" => "fact-check", "quote" => quote, "suggestion" => "Cite a source for this.",
                "explanation" => "Readers may question it." }
            ]
          }
        end
      end
    end
  end
end
