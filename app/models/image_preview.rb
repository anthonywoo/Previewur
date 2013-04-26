class ImagePreview < ActiveRecord::Base
  belongs_to :user
  attr_accessible :title, :avatar
  has_attached_file :avatar
end
