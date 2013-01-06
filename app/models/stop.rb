class Stop < ActiveRecord::Base
  belongs_to :itinerary
  attr_accessible :complete, :itinerary_id, :name, :time_to_post, :venue_id, :shout
  
  scope :approved_stops, joins(:itinerary).where('itineraries.approved=true').readonly(false)
  scope :post_due, lambda { where("(complete is null OR complete !=true) AND time_to_post < ?", Time.now ) }
  
  def check_in
    options = { :body => {:v => '20130105', :oauth_token => self.itinerary.foursquare_user.access_token, :venueId => self.venue_id, :broadcast => 'public,facebook,twitter', :shout => self.shout}}
    url = "https://api.foursquare.com/v2/checkins/add"
    unless (self.itinerary.foursquare_user.email == 'harlie.levine@gmail.com' )
      reply = HTTParty.post(url, options)
    end
    self.complete = true
    self.save
    if self.itinerary.foursquare_user.phone
      @client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
      @client.account.sms.messages.create(
        :from => '+19173380724',
        :to => self.itinerary.foursquare_user.phone,
        :body => 'Hey there! CouchCachet letting you know we just checked you into ' + self.name
      )
    end
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
