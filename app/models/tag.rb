class Tag < ActiveRecord::Base
  attr_accessible :name
  has_many :image_tags
  has_many :images, :through => :image_tags
  validates :name, :presence => true, :uniqueness => true
end
