class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy    ##we can assign each comment to a post; This code will delete any dependent comments when a post is deleted
  has_many :votes, dependent: :destroy  # A Vote should not exist without a Post, so account for that if a Post is destroyed
  has_many :favorites, dependent: :destroy   # An instance of favorite can not exist without an associated post 
  belongs_to :user      ##each post belongs to user
  belongs_to :topic      ##each post belongs to a topic
  attr_accessible :body, :title, :topic, :image   ##allows us to change body, title, topic

  default_scope order('rank DESC')  ## whenever we pull up collection of posts, the newest post created will pop up
  scope :visible_to, lambda { |user| user ? scoped : joins(:topic).where('topics.public' => true) }
  #We are using a lambda to ensure that a user is signed in. If the user is not signed in, we reference the topic model using the joins method to only display posts for publicly scoped topics.

  validates :title, length: { minimum: 5}, presence: true  ## presence -title can't be blank; validation prevents it from being saved
  validates :body, length: {minimum: 20}, presence: true    ## presence -title can't be blank
  validates :topic, presence: true    ##topic is ID
  validates :user, presence: true     ##user is ID

  after_create :create_vote  #If user submits post, they'll want to vote it up. 

  ## mount_uploader :image, ImageUploader

  def up_votes                            # We'll want a way to see only "up" or "down" votes
    self.votes.where(value: 1).count
  end

  def down_votes                          # We'll want a way to see only "up" or "down" votes
    self.votes.where(value: -1).count
  end  

  def points
    self.votes.sum(:value).to_i           # This allows us to see the total score of a post, based on the sum of "up" and "down" votes
  end

  def update_rank
    age = (self.created_at - Time.new(1970,1,1)) / 86400
    new_rank = points + age

    self.update_attribute(:rank, new_rank)
  end  

  private

  # Who ever created a post, should automatically be set to "voting" it up.
  def create_vote
    self.user.votes.create(value: 1, post: self)
  end 

end