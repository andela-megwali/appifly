class SessionsController < ApplicationController
  include Concerns::MessagesHelper

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
    redirect_to login_path, notice: successful_sign_out_message
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
      redirect_to past_bookings_path, notice: successful_sign_in_message
    else
      redirect_to login_path, notice: invalid_login_message
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
