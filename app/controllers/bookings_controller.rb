class BookingsController < ApplicationController
  def new
    @flight_selected = Flight.find(params[:select_flight])
    @passenger_enquiry = session[:passenger_enquiry]
    @booking = Booking.new
  end

  def create
  	
  end
end
