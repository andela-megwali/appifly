class SessionsController < ApplicationController
  def login
  end

  def attempt_login
    check_user
    authorize_the_user
  end

  def logout
    session[:admin_user_id] = nil
    session[:user_id] = nil
    session[:user_username] = nil
    redirect_to login_path, notice: "User successfully signed out."
  end

  private

  def check_user
    if params[:sign_in][:username] && params[:sign_in][:password]
      User.find_by(username: params[:sign_in][:username])
    end
  end

  def authorize_the_user
    if authorized_user
      set_session(authorized_user)
      redirect_to past_bookings_path, notice: "User successfully signed in."
    else
      redirect_to login_path, notice: "Invalid password or username"
    end
  end

  def authorized_user
    check_user.authenticate(params[:sign_in][:password]) if check_user
  end

  def set_session(authorized_user)
    session[:admin_user_id] = authorized_user.id if authorized_user.admin_user
    session[:user_id] = authorized_user.id
    session[:user_username] = authorized_user.username
  end
end
