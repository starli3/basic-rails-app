class Post < ActiveRecord::Base
  has_many :comments     ##we can assign each comment to a post
  belongs_to :user      ##each post belongs to user
  belongs_to :topic      ##each post belongs to a topic
  attr_accessible :body, :title, :topic, :image   ##allows us to change body, title, topic

  default_scope order('created_at DESC')  ## whenever we pull up collection of posts, the newest post created will pop up

  validates :title, length: { minimum: 5}, presence: true  ## presence -title can't be blank; validation prevents it from being saved
  validates :body, length: {minimum: 20}, presence: true    ## presence -title can't be blank
  validates :topic, presence: true    ##topic is ID
  validates :user, presence: true     ##user is ID

end