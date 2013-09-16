# == Schema Information
#
# Table name: articles
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  body        :text
#  cached_slug :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  published   :boolean
#  user_id     :integer
#  summary     :text
#

class Article < ActiveRecord::Base
    	
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  has_many :comments, :dependent => :destroy
  belongs_to :user
  belongs_to :sequence

  VALID_TITLE_REGEX = /\A[a-zA-Z\s\d]+\z/i

  validates :title,
            presence: true,
            format: { with: VALID_TITLE_REGEX },
            uniqueness: { case_sensitive: false },
            length: { maximum: 55, minimum: 6 }
    
  validates_presence_of :body
  validates_presence_of :summary
  validates :user_id, presence: true
      
  scope :published, -> { where(['published = ?', true]) }
      
  attr_writer :tag_names	
  attr_reader :per_page
  
  after_save :assign_tags
  before_create :generate_slug
    
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

    def generate_slug
      slug = "#{self.id}-#{self.title.gsub(/[^a-z0-9]+/i, '-')}".downcase
    end

    def self.all_cached
      Rails.cache.fetch('Contact.all') { all }
    end
end
