# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  email      :string(255)      not null
#  body       :text             not null
#  article_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
	attr_accessible :name, :body, :email, :article_id
	
	belongs_to :article
	
	validates_presence_of :name, :email, :article_id
	validates :body,
	          :presence => {:message => "Please enter a comment"} 
	validates_numericality_of :article_id
end
