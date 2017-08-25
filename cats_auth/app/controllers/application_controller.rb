class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :logged_in?, :correct_owner?

  def login_user!(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def current_user

    return nil unless session[:session_token]
    @user ||= User.find_by(session_token: session[:session_token])
  end

  def logged_in?
    !current_user.nil?
  end

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

  def ensure_correct_owner
    if current_user.cats.find_by(id: params[:id]).nil?
      redirect_to cats_url
    end
  end

  def correct_owner?
    !current_user.cats.find_by(id: params[:id]).nil?
  end

  def ensure_not_logged_in
    redirect_to cats_url if logged_in?
  end
end
