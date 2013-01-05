class Stop < ActiveRecord::Base
  belongs_to :itinerary
  attr_accessible :complete, :itinerary_id, :name, :time_to_post, :venue_id
  
  scope :approved_stops, joins(:itinerary).where('itineraries.approved=true')
  scope :post_due, lambda { where("(complete is null OR complete !=true) AND time_to_post < ?", Time.now ) }
  
  
end
