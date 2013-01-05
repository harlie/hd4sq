class Stop < ActiveRecord::Base
  belongs_to :itinerary
  attr_accessible :complete, :itinerary_id, :name, :time_to_post, :venue_id
end
