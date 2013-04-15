require 'spec_helper' 

describe Article do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @article = user.articles.build(title: "A working title", body: "this is the content of the article", summary: "an article")
  end

  subject { @article }

  it { should respond_to :title }
  it { should respond_to :body }
  it { should respond_to :summary }
  it { should respond_to(:user) }
  its(:user) { should == user }
  
  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Article.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when user_id is not present" do
    before { @article.user_id = nil }
    it { should_not be_valid }
  end
  
  describe  "when title is not present" do
  	before { @article.title = " "}
  	it { should_not be_valid}
  end

  describe  "when body isn't present" do
  	before { @article.body = ""}
  	it { should_not be_valid }
  end

  describe  "when summary isn't present" do
  	before { @article.summary = ""}
  	it { should_not be_valid }
  end

  describe  "when title has invalid characters" do
    before { @article.title = "some b@d st#ff"}
    it { should_not be_valid }
  end

  describe  "when title is too long" do
    before { @article.title = "a" * 51}
    it { should_not be_valid }
  end

  describe  "when title is too short" do
    before { @article.title = "a" * 5}
    it { should_not be_valid }
  end

  describe  "when title is already taken" do
    before do
      article_with_same_title = @article.dup
      article_with_same_title.title = @article.title.upcase
      article_with_same_title.save
    end

    it { should_not be_valid }
  end

  describe "assign a user" do
    specify (:user_id) { should_not be_blank }
  end
end