class Step < ActiveRecord::Base
  attr_accessible :tutorial_id, :body, :position
  belongs_to :tutorial
  
  validates :body, :presence => true
  
  before_create :assign_position
  
  private
  
  def assign_position
  	@tutorial = self.tutorial
  	@position = @tutorial.steps.size
    @position = @position + 1
    self.position = @position
  end
end
