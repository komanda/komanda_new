class CommentsController < ApplicationController
  before_filter :admin_user, only: :destroy
  
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
        @suggestion.inc(:comment_counter, 1)
      end
    end
    # redirect_to :back
    respond_to do |format|
      format.js
    end
  end

  def destroy
    if (params[:party_id])
      @party = Party.find(params[:party_id])
      @comment = @party.comments.find(params[:id])
      @comment.destroy
    else
      @suggestion = Suggestion.find(params[:suggestion_id])
      @comment = @suggestion.comments.find(params[:id])
      @comment.destroy
      @suggestion.inc(:comment_counter, -1)
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
      time = Time.now
      
      count = current_user.comments.count
      if count >= 2
        if time - current_user.comments[count - 2].created_at < 3.seconds
          return true
        end
      end
      return false
    end
end
