class SessionsController < Devise::SessionsController

  def create
    if resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_to do |format|
        format.html {redirect_to new_user_session_url}
        format.js 
     end
    end
  end

  def failure
    respond_to do |format|
      format.js 
    end
  end
end