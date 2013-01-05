class CheckinsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def checkin
    #get category from params
    checkin = JSON.parse(params['checkin'])
    categories = checkin['venue']['categories']
    home = false
    STDERR.puts params.to_s
    categories.each do |cat|
      if cat['id'] == '4bf58dd8d48988d103941735'
        home = true
      end
    end
    #get checkin id
    checkin_id = checkin['id']
    #if home reply with you have checked in at home
    #https://api.foursquare.com/v2/checkins/CHECKIN_ID/reply
    if home 
      STDERR.puts "home checkin"
      user_id = checkin['user']['id']
      user = FoursquareUser.find_by_foursquare_id(user_id)
      options = { :body => {:reply => {:text => 'lazy bum'}, :oauth_token => user.access_token}}
      url = "https://api.foursquare.com/v2/checkins/#{checkin_id}/reply"
      reply = HTTParty.post(url, options)
      STDERR.puts reply.to_s
    else
      STDERR.puts "not home checkin"
    end
    render text: 'OK'
  end
  
end