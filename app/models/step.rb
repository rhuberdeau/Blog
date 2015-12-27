# == Schema Information
#
# Table name: steps
#
#  id          :integer          not null, primary key
#  body        :text
#  position    :integer
#  tutorial_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Step < ActiveRecord::Base
  belongs_to :tutorial
  
  validates :body, :presence => true
  
  before_create :assign_position
  
  private
  
  def assign_position
  	self.position = tutorial.steps.size + 1
  end
end
