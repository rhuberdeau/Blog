class Step < ActiveRecord::Base
  attr_accessible :tutorial_id, :body, :position
  belongs_to :tutorial
  
  validates :body, :presence => true
  
  before_create :assign_position
  
  private
  
  def assign_position
  	self.position = tutorial.steps.size + 1
  end
end
