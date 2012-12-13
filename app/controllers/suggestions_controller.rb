class SuggestionsController < ApplicationController
  # before_filter :admin_user, only: [:destroy]
  before_filter :logged_in, only: [:star, :unstar, :create]
  
  def index
    suggestions_limit = 10 
    today = Time.now
    
    @suggestion = Suggestion.new
    @skip = (params[:skip].nil? ? 0 : params[:skip].to_i)
    @replace = (@skip == 0 ? true : false)
    @sort = params[:sort]
    @more = params[:more]
    
    if @sort.nil? || @sort == "date"
      @suggestions = Suggestion.skip(@skip).limit(suggestions_limit).desc(:created_at)
      @upcoming = Party.where(:when.gte => today).desc(:when).limit(3)
      @previous = Party.where(:when.lt => today).desc(:when).limit(3)
      @shares = Share.desc(:date).limit(3)
    elsif @sort == "votes"
      @suggestions = Suggestion.skip(@skip).limit(suggestions_limit).order_by(:vote_counter.desc, :comment_counter.desc, :created_at.desc)
    elsif @sort == "comments"
      @suggestions = Suggestion.skip(@skip).limit(suggestions_limit).order_by(:comment_counter.desc,:vote_counter.desc, :created_at.desc)
    end
    
    @skip += suggestions_limit
    @done = (@skip >= Suggestion.count ? true : false)
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @suggestion = Suggestion.new
  end

  def create 
    unless spam? 
      if current_user
        @suggestion = current_user.suggestions.create(params[:suggestion])
        @count = Suggestion.count
      end

      respond_to do |format|
        format.html { redirect_to suggestions_path }
        format.js
      end
    end
  end
  
  def edit
    if current_user
      @suggestion = Suggestion.find(params[:id])
      
      unless @suggestion.votes.include?(current_user.id)
        @suggestion.votes << current_user.id
        @suggestion.inc(:vote_counter, 1)
        @suggestion.save
        current_user.votes << @suggestion.id
        current_user.save
      end
      
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @suggestion = Suggestion.find(params[:id])    
    if @suggestion && authenticated_user(@suggestion)
      @suggestion.destroy
      @count = Suggestion.count
    else
      redirect_to root_url
    end
    
    respond_to do |format|
      format.js
    end
  end

  def star
    @suggestion = Suggestion.find(params[:suggestion])
    unless @suggestion.votes.include?(current_user.id)
      @suggestion.votes << current_user.id
      @suggestion.inc(:vote_counter, 1)
      @suggestion.save
      current_user.votes << @suggestion.id
      current_user.save
    end
    
    respond_to do |format|
      format.js
    end
  end

  def unstar
    @suggestion = Suggestion.find(params[:suggestion])
    @suggestion.votes.delete(current_user.id)
    @suggestion.inc(:vote_counter, -1)
    @suggestion.save
    current_user.votes.delete(@suggestion.id)
    current_user.save

    respond_to do |format|
      format.js
    end
  end

  private
      
    def spam?
      if current_user.suggestions.count > 0
        return (Time.now - current_user.suggestions.last.created_at) <= 1 ? true : false
      else
        return false
      end
    end

    def authenticated_user(suggestion)
      return current_user.suggestions.include?(suggestion) || current_user.admin
    end
end
