class Share
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActionView::Helpers::SanitizeHelper
  
  field :date, type: Date
  field :url
  field :content
  
  index({ id: 1 })
  belongs_to :user
  validate :valid_share
  
  private 
  
    def valid_share
      strip_whitespace_and_tags
      unless self.url || self.content
        errors.add :base, "URL or description must be filled out."
      end
      
      unless !self.date.nil? && self.date >= Date.current()
        errors.add :base, "Invalid date."
      end
    end
    
    def strip_whitespace_and_tags
      if self.url
        self.url = strip_tags(self.url.strip)
        if self.url.blank?
          self.url = nil
        else
          self.url.prepend("http://") unless self.url.start_with?("http://", "https://")
        end
      end
        
      if self.content
        self.content = strip_tags(self.content.strip)
        if self.content.blank?
        	self.content = nil
        end
      end
    end
end
