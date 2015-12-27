require 'spec_helper'

RSpec.describe Sequence, :type => :model do
  before do
  	@sequence = Sequence.new(name: "Test sequence")
  end

  subject { @sequence }

  it {should respond_to :name}

  describe  "when name is not present" do
    before { @sequence.name = ""}
    it { should_not be_valid}
  end
end
