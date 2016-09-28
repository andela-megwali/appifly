class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
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
    unless session[:user_id]
      redirect_to login_path, notice: "There's more but please sign in first :)"
      # return false
      # redirect_to(login_path,
                  # notice: "There's more but please sign in first :)") && return
    end
  end
end
