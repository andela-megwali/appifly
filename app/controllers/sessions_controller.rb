class SessionsController < ApplicationController
  def login
  end

  def attempt_login
    check_user
    authorize_the_user
  end

  def logout
    session[:user_id] = nil
    session[:user_username] = nil
    redirect_to login_path, notice: "User successfully signed out."
  end

  private

  def user_params
    params.require(:sign_in).permit(:username, :password)
  end

  def check_user
    if params[:sign_in][:username] && params[:sign_in][:password]
      User.find_by(username: params[:sign_in][:username])
    end
  end

  def authorize_the_user
    if check_user
      authorized_user = check_user.authenticate(params[:sign_in][:password])
      session[:user_id] = authorized_user.id
      session[:user_username] = authorized_user.username
      redirect_to past_bookings_path, notice: "User successfully signed in."
    else
      redirect_to login_path, notice: "Invalid password or username"
    end
  end
end
