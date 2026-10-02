module Ai
  module Tasks
    # A feature of the assistant: what Claude is told, the JSON shape it must
    # answer in, any server tools, and a canned answer for tests.
    # Schemas avoid string-length limits (structured outputs reject them);
    # lengths are asked for in the prompt instead.
    class Base
      class << self
        def tools = []
        def max_tokens = 16_000

        # Every object closed, every property required: what structured
        # outputs expect.
        def object(properties)
          { type: "object", properties: properties, required: properties.keys.map(&:to_s), additionalProperties: false }
        end

        def strings = { type: "array", items: { type: "string" } }

        def article_xml(input)
          <<~XML
            <title>#{input["title"]}</title>
            <summary>#{input["summary"]}</summary>
            <body>
            #{input["body"]}
            </body>
          XML
        end
      end
    end
  end
end
