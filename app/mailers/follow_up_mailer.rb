class FollowUpMailer < ActionMailer::Base
  default from: "mailer@couchcachet.com"

  def follow_up(itinerary)
    @itinerary = itinerary
    mail to: @itinerary.foursquare_user.get_email
  end
end