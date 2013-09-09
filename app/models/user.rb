# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string(255)      default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  username   :string(255)
#  bio        :text
#  approved   :boolean
#  provider   :string(255)
#  uid        :string(255)
#

class User < ActiveRecord::Base
    # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :role_id, :username, :bio, :approved, :provider, :uid
  has_secure_password
  validates :username,
            presence: true,
            length: {maximum: 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, 
             presence: true, if: "provider.nil?",
             format: { with: VALID_EMAIL_REGEX },
             uniqueness: { case_sensitive: false }
  validates :password, 
            presence:{message: "Please provide a password" },  if: "provider.nil?",
            length: { minimum: 6 }
  validates :password_confirmation, 
            presence: true,  if: "provider.nil?"

  has_many :articles
  has_many :comments
  
  scope :approved, -> { where(approved: true) }
  
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  #def self.from_omniauth(auth)
  #	where(auth.slice(:provider, :uid)).first_or_create do |user|
  #	  user.provider = auth.provider
  #	  user.uid = auth.uid
  #	  user.username = auth.info.nickname
  #	 end
  #end
  #
  #def self.new_with_session(params, session)
  #  if session["devise.user_attributes"]
  #    new(session["devise.user_attributes"], :without_protection => true) do |user|
  #      user.attributes = params
  #      user.valid?
  #    end
  #  else
  #    super
  #  end
  #end
  
 #def password_required?
 #  super && provider.blank?
 #end
 #
 #def email_required?
 #	super && provider.blank?
 #end
         
def self.from_omniauth(auth)
  provider = auth[0]['provider']
  uid      = auth[0]['uid']
  where(provider, uid).first || create_from_omniauth(auth)
end

def self.create_from_omniauth(auth)
  create! do |user|
    user.provider = auth["provider"]
    user.uid      = auth["uid"]
    user.username = auth["info"]["nickname"]
  end
end
  
  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
