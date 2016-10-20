class ApplicationController < ActionController::Base
  include Concerns::MessagesHelper

  protect_from_forgery with: :exception

  private

  def list_airport
    list_of_airport = []
    Airport.all.each do |airport|
      list_of_airport << airport.state_and_code
    end
    @list_airport = list_of_airport
  end

  def verify_user_login
    unless session[:user_id] || session[:admin_user_id]
      redirect_to login_path, notice: please_sign_in_message
    end
  end

  def verify_admin_login
    unless session[:admin_user_id]
      redirect_to root_path, notice: not_authorized_message
    end
  end
end
