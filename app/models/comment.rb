class Comment < ActiveRecord::Base
	attr_accessible :name, :body, :email, :article_id
	
	belongs_to :article
	
	validates_presence_of :name, :email, :article_id
	validate :article_exists
	
	def article_exists
	  errors.add('article does not exist') if article_id.nil? ||
  	  article_id < 1
    end	
end
