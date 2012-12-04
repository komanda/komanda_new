class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :provider
  field :uid
  field :name
  field :img_url
  field :profile_url
  field :email, default: nil
  field :admin, default: false
  field :votes, type: Array, default: []
  field :ratings, type: Hash, default: {}
  
  index({ provider: 1, uid: 1}, { unique: true })
  has_many :comments, dependent: :destroy
  has_many :suggestions, dependent: :destroy
  has_many :shares, dependent: :destroy
  attr_accessible :provider, :uid, :name, :img_url, :profile_url
  validates_presence_of :provider, :uid
  
  def self.create_with_omniauth(auth)
    
    create! do |user|
      user.provider = auth["provider"]
      user.uid      = auth["uid"]
      user.name     = auth["info"]["name"]
      user.img_url  = auth["info"]["image"]
      
      if auth["provider"] == "twitter"
        user.profile_url =  auth["info"]["urls"]["Twitter"]
      elsif auth["provider"] == "facebook"
        user.profile_url = auth["info"]["urls"]["Facebook"]
      else
        user.profile_url = auth["extra"]["raw_info"]["link"]
      end  
      
    end
  end
end
