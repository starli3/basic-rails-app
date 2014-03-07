class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, 
         :omniauthable, :omniauth_providers => [:facebook]  ##basic devise user option set -  you can do x, y, z

  # Devise needs to understands that sign-up may be authenticated with Facebook. The omniauthable declaration will also generate a "Sign in with Facebook" link on users/sign_up
  # Setup accessible (or protected) attributes for your model
  
  attr_accessible :email, :password, :password_confirmation, 
                  :remember_me, :name, :provider, :uid, :email_favorites

  # provider and uid attributes will be used to determine the type of authentication used for each user. 

  # attr_accessible :title, :body
  
  has_many :posts      ## we're defining database relationships. these are not options. we are setting up different methods that can be called. 
  has_many :comments
  has_many :votes, dependent: :destroy   # A Vote should not exist without a Post, so account for that if a Post is destroyed
  has_many :favorites, dependent: :destroy   # An instance of favorite can not exist without an associated user 
  before_create :set_member    ##before user is created, call his method

  def self.top_rated
    self.select('users.*'). # Select all attributes of the user
      select('COUNT(DISTINCT comments.id) AS comments_count'). # Count the comments made by the user
      select('COUNT(DISTINCT posts.id) AS posts_count'). # Count the posts made by the user
      select('COUNT(DISTINCT comments.id) + COUNT(DISTINCT posts.id) AS rank'). # Add the comment count to the post count and label the sum as "rank"
      joins(:posts). # Ties the posts table to the users table, via the user_id
      joins(:comments). # Ties the comments table to the users table, via the user_id
      group('users.id'). # Instructs the database to group the results so that each user will be returned in a distinct row
      order('rank DESC') # Instructs the database to order the results in descending order, by the rank that we created in this query. (rank = comment count + post count)
  end

  ROLES = %w[member moderator admin]
  def role?(base_role)
    role.nil? ? false : ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def favorited(post)    #To toggle between favorite and un-favorite states, this method which will let you know if a given user has favorited a post
    self.favorites.where(post_id: post.id).first
  end

  # This favorited method lets you know if a given user has favorited a post. 

  def voted(post)    #This method takes a post object and determines if the user has any votes on that post object.
    self.votes.where(post_id: post.id).first
  end

  private

  def set_member     #this is the method to set any new user as a member. 
    self.role = 'member'
  end

  ## mount_uploader :avatar, AvatarUploader

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      pass = Devise.friendly_token[0,20]
      user = User.new(name: auth.extra.raw_info.name,
                         provider: auth.provider,
                         uid: auth.uid,
                         email: auth.info.email,
                         password: pass,
                         password_confirmation: pass
                        )
      user.skip_confirmation!
      user.save
    end
    user
  end

end
