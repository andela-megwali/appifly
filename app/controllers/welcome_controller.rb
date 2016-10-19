class WelcomeController < ApplicationController
  layout "welcome_layout"
  def index
    list_airport
    if params[:enquiry]
      @enquire = Flight.search(
        enquiry_params[:origin],
        enquiry_params[:destination],
        Time.now,
        enquiry_params[:departure],
        "Booking"
      )

      session[:enquiry] = {
        class_selected: enquiry_params[:travel_class],
        number_travelling: enquiry_params[:passenger].to_i,
      }
      @passenger_enquiry = session[:enquiry]
    end
  end

  def about
  end

  private

  def enquiry_params
    params.require(:enquiry).permit(
      :origin,
      :destination,
      :departure,
      :travel_class,
      :passenger,
      :view_format
    )
  end
end
