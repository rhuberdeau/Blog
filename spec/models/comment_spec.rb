require 'spec_helper'

RSpec.describe Comment, :type => :model do
	let(:user) { FactoryGirl.create(:user) }
	before do
	  @article = user.articles.build(title: "A working title", body: "this is the content of the article", summary: "an article")
	  @article.save!
	  @comment = @article.comments.build(body: "this is the comment")
	end

	subject { @comment }

	it { should respond_to :user_id }
	it { should respond_to :body }
	it { should respond_to :article_id }

  it { should be_valid }

  describe "#recent" do 
  	it "returns comments created in the last 7 days" do
      comment1 = FactoryGirl.create(:comment, created_at: Date.today - 8)
      comment2 = FactoryGirl.create(:comment, created_at: Date.today - 6)
      comment3 = FactoryGirl.create(:comment, created_at: Date.today - 10)
      expect(Comment.recent.to_a).to eql([comment2])  
  	end
  end
end