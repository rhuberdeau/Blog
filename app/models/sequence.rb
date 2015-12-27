class Sequence < ActiveRecord::Base
  has_many :articles

  validates :name,
  			     presence: true
end
