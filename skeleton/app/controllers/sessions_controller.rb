class SessionsController < ApplicationController
  before_action :ensure_logged_in, only: [:destroy]
  before_action :ensure_logged_out, only: [:new, :create]

  # Render login form
  def new
    render :new
  end

  # Log user in
  def create
    @user = User.find_by_credentials(user_params) # Will this reset @user's session_token automatically?
    if @user
      self.log_in(@user)
      redirect_to cats_url
    else
      flash[:errors] = "No username/password match"
      redirect_to new_session_url
    end
  end

  # Log user out
  def destroy
    self.log_out
  end
  
end