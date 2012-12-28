class Party
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes
    
  field :title
  field :description
  # field :when, :type => DateTime
  field :date, type: Date
  field :time, type: Time
  field :flyer
  field :address
  field :map
  field :pics, type: Array, default: []
  field :views, default: 0
  field :price, type: Float, default: 15.00
  field :ratings, type: Hash, default: {}
  field :going, type: Array, default: []
  field :tickets, type: Hash, default: {}
  slug  :title
  
  index({ id: 1})
  has_many :comments, as: :commentable, dependent: :destroy
  validates_presence_of :title, :description  

  def get_rating()
    if self.ratings.empty?
      return 0
    else
      avg = 0
      self.ratings.each_value do |value|
        avg += value.to_i
      end

      return avg / self.ratings.count.to_i
    end
  end
  
  def tickets_sold
    if self.tickets.empty?
      return 0
    else
      tickets = 0
      self.tickets.each_value do |value|
        tickets += value.to_i
      end
      return tickets
    end
  end
end
