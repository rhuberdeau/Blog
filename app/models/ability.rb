class Ability
  include CanCan::Ability
 
  def initialize(user)
    user ||= User.new # guest user
 
    if user.role? :Admin
      can :manage, :all
    elsif user.role? :Moderator
      can :read, [Article, Comment]
      can [:edit, :update], Comment
    elsif user.role? :Author
       can :read, :all
       can :create, Article
       can [:update, :destroy],  Article do |article|
          article.try(:user) == user
       end
       can [:edit, :update], Comment
    end
  end
end