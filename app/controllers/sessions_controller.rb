class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    @user = User.find_by(provider: auth["provider"], uid: auth["uid"]) || User.create_with_omniauth(auth)
    @user.update_attribute(:img_url, auth["info"]["image"])
    session[:user_id] = @user.id
    
    if request.env["HTTP_REFERER"]
      redirect_to :back
    else
      redirect_to root_path
    end
  end
  
  def destroy
    session[:user_id] = nil
    
    respond_to do |format|
      format.html { redirect_to :back || root_path }
      format.js
    end
  end
end
