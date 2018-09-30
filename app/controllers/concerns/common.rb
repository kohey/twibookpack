module Common
  extend ActiveSupport::Concern

  def client_new
    Twitter::REST::Client.new do |config|
      p "***client_new****"
      p config.consumer_key = Settings.twitter.consumer_key
      p config.consumer_secret = Settings.twitter.consumer_secret
      p config.access_token = session[:oauth_token]
      p config.access_token_secret = session[:oauth_token_secret]
    end
  end

end