class ManageBookingController < ApplicationController
  before_action :verify_user_login, except: [:search]
  def past
    @bookings = Booking.past_bookings(session[:user_id])
    render "bookings/index"
  end

  def search
    @booking = Booking.find_by(reference_id: params[:reference_id])
    if @booking
      redirect_to(@booking, notice: "Booking Found.")
    else
      flash[:notice] = "Booking Not Found." unless params[:reference_id].blank?
    end
  end
end
