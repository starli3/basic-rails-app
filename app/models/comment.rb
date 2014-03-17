class Comment < ActiveRecord::Base
  belongs_to :post    ##each comment belongs to post
  belongs_to :user   ##each comment belongs to user
  attr_accessible :body, :post    ##allows us to change body and post

  validates :body, length: { minimum: 5 }, presence: true
  validates :user, presence: true

  after_create :send_favorite_emails

  default_scope order('updated_at DESC')

  private

  def send_favorite_emails
    self.post.favorites.each do |favorite|
      if favorite.user_id != self.user_id && favorite.user.email_favorites?
        FavoriteMailer.new_comment(favorite.user, self.post, self).deliver
      end
     end 
  end

end
