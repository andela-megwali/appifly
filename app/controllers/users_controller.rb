class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :verify_user_login, except: [:new,
                                             :create,
                                             :login,
                                             :attempt_login,
                                             :logout]
  before_action :verify_admin_login, only: [:index, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # send_welcome_email
      redirect_to login_path, notice: "Account created. Sign in to continue."
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to user_url, notice: "User was successfully destroyed"
  end

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

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit :title, :firstname, :lastname, :username,
                                 :password, :email, :telephone,
                                 :subscription
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

  def send_welcome_email
    Notifications.welcome_email(@user).deliver_later
  end
end
