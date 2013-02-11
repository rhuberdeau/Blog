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
             presence: true,
             format: { with: VALID_EMAIL_REGEX },
             uniqueness: { case_sensitive: false }
  validates :password,
            presence:{message: "Please provide a password" },
            length: { minimum: 6 }
  validates :password_confirmation,
            presence: true

  #has_and_belongs_to_many :roles
  has_many :articles
  
  scope :approved, where(:approved => true)  
  
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  #before_create :setup_role
  
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
  
  #def role?(role)
  # return !!self.roles.find_by_name(role.to_s)
  #end
  #
  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
  #
  ## this sets a default role for each new member. The default role value is "member" which translates to role_ids = 3 
  #def setup_role
  #	if self.role_ids.empty?
  #	  self.role_ids = [3]
  #	end
  #end
end
