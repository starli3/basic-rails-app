class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  attr_accessible :value, :post
  validates :value, inclusion: { in: [-1, 1], message: "%{value} is not a valid vote." }   #We need to rank the posts after each vote is cast

  #Since we know that a value can only be one of two values, we can use the inclusion validation to state a defined set of values that value can be. If value is anything other than 1 or -1, then a message will be returned to the user.

  after_save :update_post

  def up_vote?
    value == 1
  end

  def down_vote?
    value == -1
  end

  private

  def update_post
    self.post.update_rank  
  end  
end
