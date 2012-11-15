class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_id, :username, :bio, :approved, :provider, :uid
  validates_uniqueness_of :username
  has_and_belongs_to_many :roles
  has_many :articles
  
  scope :approved, where(:approved => true)  
  
  before_create :setup_role
  
  def self.from_omniauth(auth)
  	where(auth.slice(:provider, :uid)).first_or_create do |user|
  	  user.provider = auth.provider
  	  user.uid = auth.uid
  	  user.username = auth.info.nickname
  	 end
  end
  
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], :without_protection => true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end
  
  def password_required?
    super && provider.blank?
  end
  
  def email_required?
  	super && provider.blank?
  end
  
  def role?(role)
   return !!self.roles.find_by_name(role.to_s)
  end
  
  private
  
  # this sets a default role for each new member. The default role value is "member" which translates to role_ids = 3 
  def setup_role
  	if self.role_ids.empty?
  	  self.role_ids = [3]
  	end
  end
end
