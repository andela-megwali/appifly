class ApplicationController < ActionController::Base
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
      redirect_to login_path, notice: "There's more but please sign in first :)"
    end
  end

  def verify_admin_login
    unless session[:admin_user_id]
      redirect_to root_path,
                  notice: "You are not authorized to access the requested page"
    end
  end
end
