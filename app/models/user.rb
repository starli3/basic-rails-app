class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable  ##basic devise user option set -  you can do x, y, z

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  # attr_accessible :title, :body
  has_many :posts      ## we're defining database relationships. these are not options. we are setting up different methods that can be called. 
  has_many :comments

  before_create :set_member    ##before user is created, call his method

  ROLES = %w[member moderator admin]
  def role?(base_role)
    role.nil? ? false : ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  private

  def set_member     #this is the method to set any new user as a member. 
    self.role = 'member'
  end
  
end
