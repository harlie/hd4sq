class Stop < ActiveRecord::Base
  belongs_to :itinerary
  attr_accessible :complete, :itinerary_id, :name, :time_to_post, :venue_id
  
  scope :approved_stops, joins(:itinerary).where('itineraries.approved=true').readonly(false)
  scope :post_due, lambda { where("(complete is null OR complete !=true) AND time_to_post < ?", Time.now ) }
  
  def check_in
    options = { :body => {:v => '20130105', :oauth_token => self.itinerary.foursquare_user.access_token, :venueId => self.venue_id, :broadcast => 'public,facebook,twitter'}}
    url = "https://api.foursquare.com/v2/checkins/add"
    reply = HTTParty.post(url, options)
    self.complete = true
    self.save
  end
  
  def local_time_to_post
    offset = self.itinerary.tz_offset ? self.itinerary.tz_offset : "00:00"
    return time_to_post + Time.zone_offset(offset)
  end
  
  def self.check_in_all
    Stop.approved_stops.post_due.each do |stop|
      stop.check_in
    end
  end
end
