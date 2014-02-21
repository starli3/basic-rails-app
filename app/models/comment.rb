class Comment < ActiveRecord::Base
  belongs_to :post    ##each comment belongs to post
  belongs_to :user   ##each comment belongs to user
  attr_accessible :body, :post    ##allows us to change body and post

  validates :body, length: { minimum: 5 }, presence: true
  validates :user, presence: true
end
