class SharesController < ApplicationController
  before_filter :logged_in, only: [:new, :create]
  
  def index
    if params[:skip]
      @skip = params[:skip].to_i
      @shares = Share.desc(:date).skip(@skip).limit(10)
      @skip = @skip + 10
      @done = @skip >= @shares.count ? true : false
    else
      today = Date.current() - 8.hour
      @share = Share.new
      @shares = Share.all.desc(:date).limit(10)
      @upcoming = Party.where(:when.gte => today).desc(:when)
      @previous = Party.where(:when.lt => today).desc(:when)
      @suggestions = Suggestion.order_by(:vote_counter.desc, :comment_counter.desc, :created_at.desc).limit(3)
    end
    respond_to do |format|
      format.html
      format.js
    end
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
end
