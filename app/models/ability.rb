class Ability
  include CanCan::Ability
 
  def initialize(user)
    user ||= User.new # guest user
 
    if user.role? :Admin
      can :manage, :all
      can :publish, Article
    elsif user.role? :Moderator
      can :read, [Article, Comment]
      can [:edit, :update], Comment
    elsif user.role? :Member
       can :read, :all
       can :create, [Comment]
       can [:update],  Comment do |comment|
          comment.try(:user) == user
       end
    end
  end
end