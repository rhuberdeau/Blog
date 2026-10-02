
RSpec.describe Article, type: :model do
  let(:user) { create(:user) }
  before do
    @article = user.articles.build(title: "A working title", body: "this is the content of the article", summary: "an article")
  end

  subject { @article }

  it { should respond_to :title }
  it { should respond_to :body }
  it { should respond_to :summary }
  it { should respond_to(:user) }
  it { should be_valid }

  describe "when user_id is not present" do
    before { @article.user_id = nil }
    it { should_not be_valid }
  end

  describe "when title is not present" do
    before { @article.title = " " }
    it { should_not be_valid }
  end

  describe "when body isn't present" do
    before { @article.body = "" }
    it { should_not be_valid }
  end

  describe "when summary isn't present" do
    before { @article.summary = "" }
    it { should_not be_valid }
  end

  describe "when title has punctuation" do
    before { @article.title = "Rails 8: what changed?" }
    it { should be_valid }
    it { expect(subject.tap(&:save!).to_param).to eq("#{subject.id}-rails-8-what-changed") }
  end

  describe "when title is too long" do
    before { @article.title = "a" * 71 }
    it { should_not be_valid }
  end


  describe "when title is already taken" do
    before do
      article_with_same_title = @article.dup
      article_with_same_title.title = @article.title.upcase
      article_with_same_title.save
    end

    it { should_not be_valid }
  end

  describe "publishing" do
    it "starts as a draft" do
      expect(subject.published?).to eq(false)
      expect(Article.drafts).to include(subject.tap(&:save!))
    end

    it "keeps the first publish date and can go back to draft" do
      subject.update!(published: "1")
      first = subject.published_at
      expect(Article.published).to include(subject)

      travel 1.day do
        subject.update!(published: "1")
        expect(subject.published_at).to eq(first)
      end

      subject.update!(published: "0")
      expect(subject.published_at).to be_nil
    end
  end

  describe "word count and reading time" do
    it "counts words in the Markdown and rounds reading time up, at least a minute" do
      expect(Article.new(body: "").reading_minutes).to eq(1)
      expect(Article.new(body: "one two

three").word_count).to eq(3)
      expect(Article.new(body: ([ "word" ] * 460).join(" ")).reading_minutes).to eq(2)
      expect(Article.new(body: ([ "word" ] * 461).join(" ")).reading_minutes).to eq(3)
    end
  end

  describe "assign a user" do
    it { expect(subject.user_id).to eq(user.id) }
  end
end
