# The blog's author. There is one, created by the seed or the console (see
# README); nobody can sign up.
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :articles

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true
end
