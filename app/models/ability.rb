class Ability    #The ability class allows you to define user permissions. Created from the Cancan gem. 
  include CanCan::Ability     #authorization gem = user has ability to do what they want to do

  def initialize(user)     ##only write initialize method when you want to run code whenever an object is created based on that class. 
    user ||= User.new # guest user

    # if a member, they can manage their own posts 
    # (or create new ones)
    if user.role? :member
      can :manage, Post, user_id: user.id
      can :manage, Comment, user_id: user.id
      can :create, Vote                         # vote permission
      can :manage, Favorite, user_id: user.id
      can :read, Topic
    end

    # Moderators can delete any post or comment
    if user.role? :moderator
      can :destroy, Post
      can :destroy, Comment  
    end

    # Admins can do anything
    if user.role? :admin
      can :manage, :all  ##Admins are set to do anything
    end

    ## can :read, :all     ##users who are not members, moderators, or admin can read anything
    can :read, Topic, public: true
    can :read, Post
  end
end