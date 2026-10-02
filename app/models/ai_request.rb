# One request to the AI assistant and its outcome. The job (AiRequestJob)
# fills in the result, token usage and cost; the views poll until it's done.
class AiRequest < ApplicationRecord
  KINDS = %w[review metadata research outline].freeze
  STATUSES = %w[queued running done failed].freeze

  belongs_to :article, optional: true

  validates :kind, inclusion: { in: KINDS }
  validates :status, inclusion: { in: STATUSES }

  scope :recent, -> { order(created_at: :desc) }
  scope :this_month, -> { where(created_at: Time.current.all_month) }
  scope :notes, -> { where(kind: %w[research outline]) }

  STATUSES.each do |name|
    define_method(:"#{name}?") { status == name }
  end

  def finished?
    done? || failed?
  end

  def task
    Ai::Tasks.for(kind)
  end

  # A short label for lists: the topic for research and outlines, the
  # article title for editor requests.
  def subject
    input["topic"].presence || input["title"].presence || article&.title || "Untitled"
  end
end
