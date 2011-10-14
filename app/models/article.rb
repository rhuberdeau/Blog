class Article < ActiveRecord::Base
  attr_accessible :title, :body, :tag_names, :published, :user_id, :summary
    	
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  has_many :comments, :dependent => :destroy
  accepts_nested_attributes_for :comments
  belongs_to :user
    
  validates_presence_of :title, :body
  validates_uniqueness_of :title
  
  scope :published, lambda { {:conditions => ['published = ?', true]} }
  scope :ordered, lambda {{:order => "Created_at DESC" }}
      
  attr_writer :tag_names	
  attr_reader :per_page
  
  after_save :assign_tags  
  
  @@per_page = 5
  
  def tag_names  
    @tag_names || tags.map(&:name).join(',')  
  end
  
  def to_param
    "#{id}-#{title.gsub(/[^a-z0-9]+/i, '-')}"
  end
    
  private  
  def assign_tags  
    if @tag_names  
      self.tags = @tag_names.split(/\,/).map do |name|
      	Tag.find_or_create_by_name(name)  
      end  
    end  
  end
end
