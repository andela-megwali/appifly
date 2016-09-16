class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]

  def new
    @flight_selected = Flight.find(params[:select_flight]) if params[:select_flight]
    @passenger_enquiry = session[:passenger_enquiry]
    @booking = Booking.new
  end

  def create
  	@booking = Booking.new(booking_params)
  end

  private
	# Use callbacks to share common setup or constraints between actions.
	def set_booking
	  @booking = Booking.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def airport_params
	  #params.require(:booking).permit(:name, :country, :state, :airport_type, :rating)
	end
end
