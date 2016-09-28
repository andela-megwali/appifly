class WelcomeController < ApplicationController
  def index
    list_airport
    if params[:enquiry]
      @enquire = Flight.sorted.search_flight params[:enquiry][:origin],
                                             params[:enquiry][:destination],
                                             Time.now,
                                             params[:enquiry][:departure],
                                             "Booking"
      session[:passenger_enquiry] = {
        "Travel Class" => params[:enquiry][:travel_class],
        "Number Travelling" => params[:enquiry][:passenger].to_i,
      }
      @passenger_enquiry = session[:passenger_enquiry]
    end
  end

  def about
  end

  private

  def search_params
    params.require(:enquiry).permit :origin, :destination, :departure,
                                    :travel_class, :passenger
  end 
end
