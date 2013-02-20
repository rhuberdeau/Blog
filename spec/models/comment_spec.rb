require 'spec_helper'

describe  "Comment" do
	before do
	  @comment = Comment.new(email: "dude@mail.com", body: "this is the comment", article_id: 1)
	end

	subject { @comment }

	it { should respond_to :email }
	it { should respond_to :body }
	it { should respond_to :article_id }

    it { should be_valid }
end