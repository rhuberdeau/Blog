class Article < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  belongs_to :user

  attr_writer :tag_names

  validates :title, presence: true, length: { maximum: 70 }, uniqueness: { case_sensitive: false }
  validates :summary, :body, presence: true

  scope :published, -> { where.not(published_at: nil) }
  scope :drafts,    -> { where(published_at: nil) }

  after_save :assign_tags

  def published?
    published_at.present?
  end
  alias_method :published, :published?

  # The form's "published" checkbox. Publishing keeps the first publish
  # date; unpublishing turns the article back into a draft.
  def published=(value)
    if ActiveModel::Type::Boolean.new.cast(value)
      self.published_at ||= Time.current
    else
      self.published_at = nil
    end
  end

  def tag_names
    @tag_names || tags.map(&:name).join(",")
  end

  def to_param
    [ id, title.parameterize.presence ].compact.join("-")
  end

  private
    def assign_tags
      if @tag_names
        names = @tag_names.split(",").map(&:strip).reject(&:blank?).uniq
        self.tags = names.map { |name| Tag.find_or_create_by(name: name) }
      end
    end
end
