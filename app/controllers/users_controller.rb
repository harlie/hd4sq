class UsersController < ApplicationController
  layout "users"
  def new
    # render text: "<a href='#{new_foursquare_client_path}'><img src='https://playfoursquare.s3.amazonaws.com/press/logo/connect-black.png' /></a>"
  end

  def show
    @user = current_user.name
    # render text: "hello #{current_user.name}.  Welcome to CouchCachet.  Next time you check in from home, we'll be in touch."
  end

  private
  def current_user
    @current_user ||= FoursquareUser.find(session[:user_id])
  end
end