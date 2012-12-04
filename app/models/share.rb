class Share
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActionView::Helpers::SanitizeHelper
  
  field :content
  
  index({ id: 1})
  belongs_to :user
  validate :valid_share
  
  private 
  	
  	def valid_share
      strip_whitespace_and_tags
      
      unless self.content
        errors.add :base, "Share cannot be blank."  
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
