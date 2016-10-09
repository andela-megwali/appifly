module FlightsHelper
  def index_for_pagination(index)
    if params[:page].to_i < 1
      (params[:page].to_i * 30) + (index + 1)
    else
      ((params[:page].to_i - 1) * 30) + (index + 1)
    end
  end

  def flight_status_display(flight)
    status = flight.status
    status = "Past" if Time.now > flight.departure && status == "Booking"
    status
  end
end
