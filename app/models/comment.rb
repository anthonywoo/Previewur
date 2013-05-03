class Comment < ActiveRecord::Base
  attr_accessible :body, :user_id, :image_id
  belongs_to :user
  belongs_to :image
  validates :body, :image_id, :user, :presence => true

  make_voteable

  
end
