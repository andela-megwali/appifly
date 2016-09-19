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
    @booking.flight_id = @passenger_enquiry["Flight Selected"]
    if @booking.save
      redirect_to @booking, notice: "Booking was successfully created."
    else
      render :new
    end
  end

  def show
    additional_booking_details
    session[:passenger_enquiry] = nil
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      redirect_to @booking, notice: "Booking was successfully updated."
    else
      render :edit
    end
  end

  private
	# Use callbacks to share common setup or constraints between actions.
	def set_booking
	  @booking = Booking.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def booking_params
	  params.require(:booking).permit(:reference_id, :paid, :total_cost,
      :travel_class, :user_id, :flight_id, passengers_attributes: [:id, :title,
        :firstname, :lastname, :email, :telephone, :nationality, :luggage])
	end

  def set_flight_select
    session[:passenger_enquiry]["Flight Selected"] = params[:select_flight] if params[:select_flight]
    @passenger_enquiry = session[:passenger_enquiry]
    if @passenger_enquiry && @passenger_enquiry["Flight Selected"]
      @flight_selected = Flight.find(@passenger_enquiry["Flight Selected"])
    elsif @booking
      @flight_selected = Flight.find(@booking.flight_id)
    end
    redirect_to root_path unless @flight_selected
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
end
