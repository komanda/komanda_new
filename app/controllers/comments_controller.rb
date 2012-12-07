class CommentsController < ApplicationController
  # before_filter :admin_user, only: :destroy
  before_filter :logged_in, only: :create

  
  def create
    unless spam?   
      if params[:party_id]
        @party = Party.find(params[:party_id])
        @comment = @party.comments.create(params[:comment]) 
        @comment.user_id = current_user.id
        @comment.save     
        @comment_count = @party.comments.count
      else
        @suggestion = Suggestion.find(params[:suggestion_id])
        @comment = @suggestion.comments.create(params[:comment])
        @comment.user_id = current_user.id
        @comment.save
        @suggestion.update_attribute(:comment_counter, @suggestion.comments.count)
      end
    end
    
    respond_to do |format|
      format.js
    end
  end

  def destroy
    if (params[:party_id])
      @party = Party.find(params[:party_id])
      @comment = @party.comments.find(params[:id])
      if authenticated_user(@comment)
        @comment.destroy
      else
        redirect_to root_url
      end
    else
      @suggestion = Suggestion.find(params[:suggestion_id])
      @comment = @suggestion.comments.find(params[:id])
      if authenticated_user(@comment)
        @comment.destroy
        @suggestion.update_attribute(:comment_counter, @suggestion.comments.count)
      else
        redirect_to root_url
      end
    end

    respond_to do |format|
      format.js
    end
  end
  
  def index
    default_limit = 3
    comment_limit = 50

    if (params[:suggestion_id])
      @suggestion = Suggestion.find(params[:suggestion_id]) 
      
      if params[:skip]
        # View more comments
        @skip = params[:skip].to_i
        @comments = @suggestion.comments.skip(@skip).limit(comment_limit)
        
        if @skip - comment_limit < 0
          @limit = @skip
          @skip = 0
        else
          @skip -= comment_limit
        end
      elsif params[:limit]
        @comments = @suggestion.comments.limit(params[:limit])
        @done = true
      else
        # View all comments
        @comments = @suggestion.comments.limit(@suggestion.comments.count - default_limit)
      end
    else
      @party = Party.find(params[:party_id])

      if params[:skip]
        # View more comments
        @skip = params[:skip].to_i
        @comments = @party.comments.skip(@skip).limit(comment_limit)
        
        if @skip - comment_limit < 0
          @limit = @skip
          @skip = 0
        else
          @skip -= comment_limit
        end
      elsif params[:limit]
        @comments = @party.comments.limit(params[:limit])
        @done = true
      else
        # View all comments
        @comments = @party.comments.limit(@party.comments.count - default_limit)
      end
      
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  private
    def spam?
      if current_user.comments.count > 0
        return (Time.now - current_user.comments.last.created_at) <= 1 ? true : false
      else
        return false
      end
    end

    def authenticated_user(comment)
      return current_user.comments.include?(comment) || current_user.admin
    end
end
