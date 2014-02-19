class Comment < ActiveRecord::Base
  belongs_to :post    ##each comment belongs to post
  belongs_to :user  
  attr_accessible :body, :post    ##allows us to change body

  validates :body, length: { minimum: 5 }, presence: true
  validates :user, presence: true
end
