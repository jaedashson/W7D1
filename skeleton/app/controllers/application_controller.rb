class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end 

  def logged_in?
    !!current_user
    # if current_user is an actual user, !current_user = false, !!current_user = true
    # if current_user is nil, !current_user = true, !!current_user = false
  end

  def log_in(user)
    session[:session_token] = user.reset_session_token!
  end

  def log_out
    current_user.reset_session_token
    session[:session_token] = nil
    redirect_to new_session_url    
  end

  def ensure_logged_in
    redirect_to new_session_url unless logged_in?
  end 

  def ensure_logged_out
    redirect_to cats_url if logged_in?
  end


  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
