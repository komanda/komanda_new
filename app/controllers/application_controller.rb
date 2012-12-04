class ApplicationController < ActionController::Base
  protect_from_forgery


  
  helper_method :current_user, :admin_user, :admin_user?, :pictures
  
  def save_return_to
    session[:return_to] = request.referer
  end
  
  def return_to(default)
    redirect_to(session.delete(:return_to) || default)
  end

  private
  
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end  
    
    def admin_user
      redirect_to root_path unless current_user && admin_user?
    end

    def logged_in
      redirect_to root_path unless current_user
    end
    
    def admin_user?
      current_user.admin
    end

    def pictures
      get_pictures
    end

    def get_pictures
      @pictures = []

      Party.all.each do |party|
        party.pics.each do |picture|
          @pictures << picture
        end
      end

      return @pictures
    end
end
