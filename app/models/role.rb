# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ActiveRecord::Base
	attr_accessible :name
	has_and_belongs_to_many :users
	
	validates_presence_of :name
end
