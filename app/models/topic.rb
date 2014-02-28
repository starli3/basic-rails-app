class Topic < ActiveRecord::Base
  attr_accessible :description, :name, :public   ##allows us to change description, name, public
  has_many :posts, dependent: :destroy  ##we can assign each post to a topic; This code will delete any dependent posts when a topic is deleted
end