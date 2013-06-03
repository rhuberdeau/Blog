require 'spec_helper' 

describe  "tutorial" do
	before do
	  @tutorial = Tutorial.new(name: "test tutorial", summary: "i'll let you guess what this is about")
	end
	subject { @tutorial }
    
    it {should respond_to :name}
    it {should respond_to :summary}
    it {should respond_to :permalink}

	describe  "when name is blank" do
	  before { @tutorial.name = " "}
	  it { should_not be_valid}
	end

	describe  "when summary is blank" do
	  before { @tutorial.summary = " "}
	  it { should_not be_valid}
	end

	describe  "when name is already taken" do
	  before do
        tutorial_with_same_name = @tutorial.dup
        tutorial_with_same_name.name = @tutorial.name.upcase
        tutorial_with_same_name.save
      end
      it { should_not be_valid}
	end

	describe  "assign a permalink" do
	  specify (:permalink) { should_not be_blank }
	end
end