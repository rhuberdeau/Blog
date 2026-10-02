describe Ai do
  it "prices tokens and web searches" do
    expect(described_class.cost_usd(model: "claude-opus-5", input_tokens: 2_000, output_tokens: 1_000, web_searches: 2))
      .to be_within(0.00001).of(0.01 + 0.025 + 0.02)
  end

  describe Ai::Budget do
    around do |example|
      previous = ENV["AI_MONTHLY_BUDGET_USD"]
      ENV["AI_MONTHLY_BUDGET_USD"] = "1"
      example.run
    ensure
      ENV["AI_MONTHLY_BUDGET_USD"] = previous
    end

    it "refuses new requests once this month's spend reaches the limit" do
      AiRequest.create!(kind: "review", status: "done", cost_usd: 0.99, created_at: 1.month.ago)
      AiRequest.create!(kind: "review", status: "done", cost_usd: 0.6)
      expect { Ai::Budget.check! }.not_to raise_error

      AiRequest.create!(kind: "review", status: "done", cost_usd: 0.4)
      expect { Ai::Budget.check! }.to raise_error(Ai::BudgetExceeded, /\$1\.00/)
    end
  end

  describe Ai::Client do
    it "refuses to call Anthropic from tests" do
      expect { Ai::Client.new }.to raise_error(/must not call Anthropic from tests/)
    end
  end

  describe Ai::OutlineDraft do
    let(:author) { create(:user) }

    it "turns an outline and its research sources into a unique draft" do
      create(:article, user: author, title: "Thinking about SQLite")
      outline = AiRequest.create!(
        kind: "outline", status: "done",
        input: { "topic" => "SQLite", "research" => { "sources" => [ { "title" => "SQLite docs", "url" => "https://sqlite.org/docs", "supports" => "WAL mode" } ] } },
        result: { "title_options" => [ "Thinking about SQLite" ], "summary" => "Why.",
                  "sections" => [ { "heading" => "Why", "points" => [ "Small apps" ] } ] }
      )

      article = described_class.new(outline, author: author).create!

      expect(article.title).to eq("Thinking about SQLite (2)")
      expect(article).not_to be_published
      expect(article.body).to include("## Why", "- Small apps", "## Sources", "[SQLite docs](https://sqlite.org/docs): WAL mode")
    end
  end
end
