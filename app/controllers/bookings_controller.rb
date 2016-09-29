class BookingsController < ApplicationController
  before_action :verify_admin_login, only: [:index]
  before_action :verify_user_login, except: [:new,
                                             :create,
                                             :show,
                                             :search_booking]
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :set_flight_select, only: [:new, :create, :show, :edit, :update]

  def index
    @bookings = Booking.all.paginate(page: params[:page], per_page: 30)
  end

  def new
    @booking = Booking.new
    @passenger_enquiry["Number Travelling"].times { @booking.passengers.build }
    @booking.passengers.build if @passenger_enquiry["Number Travelling"] < 1
  end

  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      additional_booking_details
      session[:passenger_enquiry] = nil
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
      cost_calculator
      send_booking_update_notification
      redirect_to @booking, notice: "Booking was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @booking.destroy
    redirect_to bookings_url, notice: "Booking was successfully Cancelled"
  end

  def past
    @bookings = Booking.where(user_id: session[:user_id])
    render "index"
  end

  def search_booking
    @booking = Booking.find_by(reference_id: params[:reference_id])
    if @booking
      redirect_to(@booking, notice: "Booking Found.")
    else
      flash[:notice] = "Booking Not Found."
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit :travel_class,
                                    passengers_attributes: [:id,
                                                            :nationality,
                                                            :firstname,
                                                            :email,
                                                            :title,
                                                            :telephone,
                                                            :lastname,
                                                            :luggage,
                                                            :_destroy]
  end

  def set_flight_select
    session[:passenger_enquiry]["Flight Selected"] = params[:select_flight] if
      params[:select_flight]
    @passenger_enquiry = session[:passenger_enquiry]
    flight_from_passenger_enquiry
    flight_from_booking
    redirect_to :back, notice: "Select a flight first!" unless @flight_selected
  end

  def flight_from_booking
    @flight_selected = Flight.find(@booking.flight_id) and return if @booking
  end

  def flight_from_passenger_enquiry
    if flight_is_selected
      @flight_selected = Flight.find(@passenger_enquiry["Flight Selected"])
    end
  end

  def flight_is_selected
    @passenger_enquiry.key? "Flight Selected"
  end

  def booking_ref_generator
    @booking.reference_id = @flight_selected.flight_code + "-" +
                            rand(1000..9999).to_s + "-" + rand(1000..9999).
                            to_s + "-" + rand(1000..9999).to_s + "-" +
                            @booking.flight_id.to_s + @booking.passengers.size.
                            to_s + @booking.id.to_s
  end

  def cost_calculator
    multiplier = { "Economy" => 1, "Business" => 1.5, "First" => 2 }
    travel_value = multiplier[@booking.travel_class] * @booking.passengers.size
    @booking.total_cost = travel_value * @flight_selected.flight_cost
    @booking.save
  end

  def send_booking_notification
    @booking.passengers.each do |passenger|
      Notifications.booking_confirmation(passenger).deliver_later
    end
  end

  def send_booking_update_notification
    @booking.passengers.each do |passenger|
      Notifications.booking_update_confirmation(passenger).deliver_later
    end
  end

  def additional_booking_details
    @booking.flight_id = @flight_selected.id
    @booking.user_id = session[:user_id] if session[:user_id]
    booking_ref_generator
    cost_calculator
    send_booking_notification
  end
end
