class Article < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  belongs_to :user

  attr_writer :tag_names

  VALID_TITLE_REGEX = /\A[a-zA-Z\s\d]+\z/i

  validates_presence_of :body
  validates_presence_of :summary
  validates             :user_id, presence: true
  validates             :title,
                        presence: true,
                        format: { with: VALID_TITLE_REGEX },
                        uniqueness: { case_sensitive: false },
                        length: { maximum: 70, minimum: 6 }

  scope :published, -> { where(published: true) }
  self.per_page = 5

  after_save :assign_tags

  def tag_names
    @tag_names || tags.map(&:name).join(',')
  end

  def to_param
    "#{id}-#{title.gsub(/[^a-z0-9]+/i, '-')}"
  end

  private
    def assign_tags
      if @tag_names
        names = @tag_names.split(',').map(&:strip).reject(&:blank?).uniq
        self.tags = names.map { |name| Tag.find_or_create_by(name: name) }
      end
    end
end
