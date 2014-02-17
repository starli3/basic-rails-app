class Comment < ActiveRecord::Base
  belongs_to :post    ##each comment belongs to post
  attr_accessible :body    ##allows us to change body
end
