class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def login_required
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    else
      redirect_to home_path
    end
  end

  private

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
end
