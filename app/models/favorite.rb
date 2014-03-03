class Favorite < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  # attr_accessible :title, :body
  attr_accessible :post
end
