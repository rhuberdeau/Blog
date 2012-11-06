class Comment < ActiveRecord::Base
	attr_accessible :name, :body, :email, :article_id
	
	belongs_to :article
	
	validates_presence_of :name, :email, :article_id
	validates :body,
	          :presence => {:message => "Please enter a comment"} 
	validates_numericality_of :article_id
end
