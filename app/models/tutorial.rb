class Tutorial < ActiveRecord::Base
  attr_accessible :name, :summary, :permalink 	
  has_many :steps, :order => 'id'

  validates :name, :presence => true,
            	   :length => { :maximum => 50 },
            	   :uniqueness => { :case_sensitive => false }  

  validates :summary, :presence => true,
  					  :length => { :maximum => 2000 }
  
  before_create :set_up_permalink
  
  def to_param
  	permalink
  end
  
  private
  
  def set_up_permalink
  	permalink = self.name.gsub(' ', '-').gsub(/[^a-zA-Z0-9\_\-\.]/, '').downcase
    self.permalink = permalink
  end
end
