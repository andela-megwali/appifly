class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :set_flight_select, only: [:new, :create, :show, :edit, :update]

  def index
    @bookings = Booking.all
  end

  def new
    @booking = Booking.new
    @passenger_enquiry["Number Travelling"].times { @booking.passengers.build }
    @booking.passengers.build if @passenger_enquiry["Number Travelling"] < 1
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.flight_id = @flight_selected.id
    if @booking.save
      additional_booking_details
      send_booking_notification
      session[:passenger_enquiry] = nil if @booking.save
      redirect_to @booking, notice: "Booking was successfully created."
    else
      render :new
    end
  end

  def show
  end

  def edit
    @booking.passengers.build
  end

  def update
    if @booking.update(booking_params)
      additional_booking_details
      redirect_to @booking, notice: "Booking was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @booking.destroy
    redirect_to bookings_url, notice: "Booking was successfully destroyed"
  end

  private
	# Use callbacks to share common setup or constraints between actions.
	def set_booking
	  @booking = Booking.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def booking_params
	  params.require(:booking).permit(:paid, :travel_class, :user_id, passengers_attributes: [:id, :title,
        :firstname, :lastname, :email, :telephone, :nationality, :luggage, :_destroy])
	end

  def set_flight_select
    session[:passenger_enquiry]["Flight Selected"] = params[:select_flight] if params[:select_flight]
    @passenger_enquiry = session[:passenger_enquiry]
    if @passenger_enquiry && @passenger_enquiry["Flight Selected"]
      @flight_selected = Flight.find(@passenger_enquiry["Flight Selected"])
    elsif @booking
      @flight_selected = Flight.find(@booking.flight_id)
    end
    redirect_to :back, notice: 'Please select a flight first!' unless @flight_selected
  end

  def booking_ref_generator
    @flight_selected.flight_code + rand(1000..9999).to_s + "-" + rand(1000..9999).to_s + "-" + rand(1000..9999).to_s + "-" + @booking.flight_id.to_s 
  end

  def cost_calculator
    multiplier = { "Economy" => 1, "Business" => 1.5, "First" => 2 }
    travel_value = multiplier[@booking.travel_class]
    travel_value * @flight_selected.flight_cost * @booking.passengers.count
  end

  def additional_booking_details
    @booking.total_cost = cost_calculator
    @booking.reference_id = booking_ref_generator + @booking.passengers.
      count.to_s + @booking.id.to_s unless @booking.reference_id
    @booking.save
  end

  def send_booking_notification
    @booking.passengers.each do |passenger| 
      Notifications.booking_confirmation(passenger).deliver_now
    end
  end
end
