class CheckinsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def checkin
    #get category from params
    checkin = JSON.parse(params['checkin'])
    categories = checkin['venue']['categories']
    home = false
    authorized = false
    categories.each do |cat|
      if cat['id'] == '4bf58dd8d48988d103941735'
        home = true
      end
    end
    #Not sure why we match both
    if checkin["shout"] && checkin['shout'] =~ /#couch/
      authorized = true
    end
    #get checkin id
    checkin_id = checkin['id']
    #if home reply with you have checked in at home
    #https://api.foursquare.com/v2/checkins/CHECKIN_ID/reply
    if home && authorized
      user_id = checkin['user']['id']
      user = FoursquareUser.find_by_foursquare_id(user_id)
      itin = Itinerary.create_itinerary_from_checkin(checkin, user)
      #url = itinerary_url(itin.to_s, :protocol => "http")
      #msg = "You may be at home, but click and look like you did this:\n" + itin.to_reply
      #options = { :body => {:v => '20130105', :text => msg, :url => url,:oauth_token => user.access_token}}
      #url = "https://api.foursquare.com/v2/checkins/#{checkin_id}/reply"
      #reply = HTTParty.post(url, options)
    else
    end
    render text: 'OK'
  end
  
end