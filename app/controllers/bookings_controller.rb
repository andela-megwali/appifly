class BookingsController < ApplicationController
  include Concerns::MessagesHelper

  before_action :verify_user_login, except: [:new, :create, :show, :search]
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :set_flight_select, only: [:new, :create, :show, :edit, :update]

  def index
    redirect_to(past_bookings_path) && return unless session[:admin_user_id]
    @bookings = Booking.all
  end

  def new
    @booking = Booking.new
    @passenger_enquiry["number_travelling"].times { @booking.passengers.build }
    @booking.passengers.build if @passenger_enquiry["number_travelling"] < 1
  end

  def create
    @booking = Booking.new(booking_params)
    add_booking_details
    render(:new) && return unless @booking.save
    session[:enquiry] = nil
    redirect_to @booking, notice: booking_created_message
  end

  def show
  end

  def edit
  end

  def update
    render(:edit) && return unless @booking.update(booking_params)
    redirect_to @booking, notice: booking_updated_message
  end

  def destroy
    @booking.destroy
    redirect_to past_bookings_path, notice: booking_cancelled_message
  end

  def past
    @bookings = Booking.past_bookings(session[:user_id])
    render "bookings/index"
  end

  def search
    return false if params[:reference_id].blank?
    @booking = Booking.find_by(reference_id: params[:reference_id])
    (flash[:notice] = booking_not_found_message) && return unless @booking
    redirect_to(@booking, notice: booking_found_message)
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(
      :travel_class,
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
    )
  end

  def set_flight_select
    if params[:select_flight] && session[:enquiry]
      session[:enquiry]["flight_selected"] = params[:select_flight]
    end
    @passenger_enquiry = session[:enquiry] if session[:enquiry]
    find_flight
    redirect_to :back, notice: select_a_flight_message unless @flight_selected
  end

  def find_flight
    if @passenger_enquiry && @passenger_enquiry["flight_selected"]
      @flight_selected = Flight.find(@passenger_enquiry["flight_selected"])
    elsif @booking
      @flight_selected = Flight.find(@booking.flight_id)
    end
  end

  def add_booking_details
    @booking.flight_id = @flight_selected.id
    @booking.user_id = session[:user_id] if session[:user_id]
  end
end
