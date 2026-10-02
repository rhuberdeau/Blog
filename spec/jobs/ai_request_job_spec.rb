describe AiRequestJob do
  it "stores the result, usage and cost" do
    request = AiRequest.create!(kind: "research", input: { "topic" => "SQLite" })

    described_class.perform_now(request.id)

    request.reload
    expect(request).to be_done
    expect(request.result["summary"]).to eq("Notes about SQLite.")
    expect(request.web_searches).to eq(1)
    expect(request.cost_usd).to be > 0
  end

  it "records a failure instead of raising" do
    request = AiRequest.create!(kind: "review", input: { "body" => "Text" })
    allow(Ai::Client).to receive(:call).and_raise(Ai::Failed, "Claude declined this request.")

    described_class.perform_now(request.id)

    expect(request.reload).to be_failed
    expect(request.error).to eq("Claude declined this request.")
  end

  it "doesn't run a request twice" do
    request = AiRequest.create!(kind: "review", status: "done", input: {}, result: { "findings" => [] })
    expect(Ai::Client).not_to receive(:call)
    described_class.perform_now(request.id)
  end
end
