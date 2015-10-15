class Sequence < ActiveRecord::Base
  attr_accessible :name
  has_many :articles

  validates :name,
  			     presence: true
end
