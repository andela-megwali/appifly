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
end
