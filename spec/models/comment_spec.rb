require 'spec_helper'

describe  "Comment" do
	let(:user) { FactoryGirl.create(:user) }
	before do
	  @article = user.articles.build(title: "A working title", body: "this is the content of the article", summary: "an article")
	  @comment = @article.comments.build(email: "dude@mail.com", body: "this is the comment")
	end

	subject { @comment }

	it { should respond_to :user_id }
	it { should respond_to :body }
	it { should respond_to :article_id }

    it { should be_valid }
end