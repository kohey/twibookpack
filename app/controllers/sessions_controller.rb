class SessionsController < ApplicationController
    def callback
    auth = request.env['omniauth.auth']
    user = User.find_by(provider: auth["provider"], uid: auth["uid"]) || User.create_with_omniauth(auth) #ユーザーがいなければ作る。
    session[:user_id] = user.id
    session[:oauth_token] = auth['credentials']['token']
    session[:oauth_token_secret] = auth['credentials']['secret']
    # binding.pry
    p "***callback end****"
    p session.keys
    redirect_to home_path
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
