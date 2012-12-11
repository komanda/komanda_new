class SharesController < ApplicationController
  helper_method :authenticated_user?
  before_filter :logged_in, only: [:new, :create]
  
  def index
    @share = Share.new
    @shares = Share.all.desc(:created_at)
  end

  def new
    @share = Share.new
  end

  def create 
    @share = current_user.shares.new(params[:share])
    respond_to do |format|
      if @share.save
        format.html { redirect_to shares_path }
      else
        format.html { render 'new' }
      end
      @count = Share.count
      format.js
    end
  end

  def destroy
    @share = Share.find(params[:id])
    if authenticated_user?(@share)
      @share.destroy
      @count = Share.count
    else 
      redirect_to root_path
    end
    respond_to do |format|
      format.js
    end
  end

  private
    def spam?
      if current_user.shares.count > 0
        return (Time.now - current_user.shares.last.created_at) <= 1 ? true : false
      else
        return false
      end
    end
    
    def authenticated_user?(share)
      return current_user.shares.include?(share) || current_user.admin
    end
end
