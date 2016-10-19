class BookingsController < ApplicationController
  before_action :verify_admin_login, only: [:index]
  before_action :verify_user_login, except: [:new, :create, :show]
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :set_flight_select, only: [:new, :create, :show, :edit, :update]

  def index
    @bookings = Booking.all
  end

  def new
    @booking = Booking.new
    @passenger_enquiry["number_travelling"].times { @booking.passengers.build }
    @booking.passengers.build if @passenger_enquiry["number_travelling"] < 1
  end

  def create
    @booking = Booking.new(booking_params)
    additional_booking_details
    if @booking.save
      session[:enquiry] = nil
      redirect_to @booking, notice: "Booking was successfully created."
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      cost_calculator
      redirect_to @booking, notice: "Booking was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @booking.destroy
    redirect_to past_bookings_path, notice: "Booking was successfully Cancelled"
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit :travel_class,
                                    passengers_attributes: [
                                      :id,
                                      :nationality,
                                      :firstname,
                                      :email,
                                      :title,
                                      :telephone,
                                      :lastname,
                                      :luggage,
                                      :_destroy
                                    ]
  end

  def set_flight_select
    if params[:select_flight] && session[:enquiry]
      session[:enquiry]["flight_selected"] = params[:select_flight]
    end
    @passenger_enquiry = session[:enquiry] if session[:enquiry]
    find_flight
    redirect_to :back, notice: "Select a flight first!" unless @flight_selected
  end

  def find_flight
    if @passenger_enquiry && @passenger_enquiry["flight_selected"]
      @flight_selected = Flight.find(@passenger_enquiry["flight_selected"])
    elsif @booking
      @flight_selected = Flight.find(@booking.flight_id)
    end
  end

  def additional_booking_details
    @booking.flight_id = @flight_selected.id
    @booking.user_id = session[:user_id] if session[:user_id]
    cost_calculator
  end

  def cost_calculator
    multiplier = { "Economy" => 1, "Business" => 1.5, "First" => 2 }
    travel_value = multiplier[@booking.travel_class] * @booking.passengers.size
    @booking.total_cost = travel_value * @booking.flight.cost
    @booking.save
  end
end
