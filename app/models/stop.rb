class Stop < ActiveRecord::Base
  belongs_to :itinerary
  attr_accessible :complete, :itinerary_id, :name, :time_to_post, :venue_id
  
  scope :approved_stops, joins(:itinerary).where('itineraries.approved=true')
  scope :post_due, lambda { where("(complete is null OR complete !=true) AND time_to_post < ?", Time.now ) }
  
  def check_in
    options = { :body => {:v => '20130105', :oauth_token => self.itinerary.foursquare_user.access_token, :venue_id => self.venue_id, :broadcast => 'public,facebook,twitter'}}
    url = "https://api.foursquare.com/v2/checkins/add"
    reply = HTTParty.post(url, options)
    STDERR.puts reply.body
    self.complete = true
    self.save
  end
end
