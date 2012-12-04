class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActionView::Helpers::SanitizeHelper
  
  field :content
  
  index({ id: 1})
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  validate :valid_comment
  
  private 
    
    def valid_comment
      strip_whitespace_and_tags
      
      unless self.content && self.user_id
        errors.add :base, "Comment cannot be blank."  
      end
    end

    def strip_whitespace_and_tags
      if self.content
        self.content = strip_tags(self.content.strip)
        if self.content.empty?
          self.content = nil
        end
      end
    end
    
end
