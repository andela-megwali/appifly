class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :verify_user_login, except: [:login, :attempt_login, :logout]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "User was successfully created."
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
    if params[:sign_in][:username].present? && params[:sign_in][:password].present?
      found_user = User.find_by(:username => params[:sign_in][:username])
    end
    authorized_user = found_user.authenticate(params[:sign_in][:password]) if found_user
    if authorized_user
      session[:user_id] = authorized_user.id
      session[:user_username] = authorized_user.username
      redirect_to root_path, notice: "User successfully signed in."
    else
      redirect_to login_path, notice: "Invalid password or username"
    end
  end

  def logout
    session[:user_id] = nil
    session[:user_username] = nil
    redirect_to @user, notice: "User successfully signed out."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the internet, only allow the white list through.
  def user_params
    params.require(:user).permit :title, :firstname, :lastname, :username,
                                 :password_digest, :email, :telephone,
                                 :subscription
  end
end
