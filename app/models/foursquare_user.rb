class FoursquareUser < ActiveRecord::Base
  def name
    client.user_name
  end

  def client
    @client ||= FoursquareClient.new(access_token)
  end

  def get_email
    url = "https://api.foursquare.com/v2/users/self?v=20130105&oauth_token=#{self.access_token}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)
    STDERR.puts response.body
    
    
    result = JSON.parse(response.body)
    STDERR.puts result.to_s
    email = result['response']['user']['contact']['email']
    
  end
  class << self
    def find_or_create_by_access_token(access_token)
      client = FoursquareClient.new(access_token)

      unless user = self.find_by_foursquare_id(client.user_id)
        user = self.new
        user.foursquare_id = client.user_id
        user.access_token = client.access_token
        user.save!
      end
      user
    end
  end
end