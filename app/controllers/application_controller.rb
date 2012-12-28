class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user, :admin_user, :admin_user?, :authenticated_user?

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
    
    def authenticated_user?(object)
      if current_user
        if object.class.to_s == "Share"
          return current_user.shares.include?(object) || current_user.admin
        elsif object.class.to_s == "Suggestion"
          return current_user.suggestions.include?(object) || current_user.admin
        else
          return current_user.comments.include?(object) || current_user.admin
        end
      end
      
      return false
    end
end
