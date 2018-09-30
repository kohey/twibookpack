class HomeController < ApplicationController
    def index
        p "***home index***"
        p session.keys
        p session[:oauth_token]
        p session[:oauth_token_secret]
        # binding.pry
    end
end
