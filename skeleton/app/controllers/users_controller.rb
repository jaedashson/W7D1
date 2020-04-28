class UsersController < ApplicationController
  before_action :ensure_logged_out

  def new
    render :new
  end

  def create
    @user = User.new(user_params) # This will generation the session_token for @user

    if @user.save
      self.log_in(@user) # ApplicationController method
      # redirect somewhere
    else
      flash.now[:errors] = @user.errors.full_message
      render :new
    end
  end
end