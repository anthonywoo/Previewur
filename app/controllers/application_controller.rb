class ApplicationController < ActionController::Base
  before_filter :create_temp_image
  protect_from_forgery

  def create_temp_image
    @image = Image.new
  end

  def current_user
    User.find(1)
  end
end
