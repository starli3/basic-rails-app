class Ability
  include CanCan::Ability

  def initialize(user)     ##only write initialize method when you want to run code whenever an object is created based on that class. 
    user ||= User.new # guest user

    # if a member, they can manage their own posts 
    # (or create new ones)
    if user.role? :member
      can :manage, Post, :user_id => user.id
      can :manage, Comment, :user_id => user.id
      can :create, Vote
    end

    # Moderators can delete any post or comment
    if user.role? :moderator
      can :destroy, Post
      can :destroy, Comment
    end

    # Admins can do anything
    if user.role? :admin
      can :manage, :all
    end

    can :read, :all     ##users who are not members, moderators, or admin can read anything
  end
end