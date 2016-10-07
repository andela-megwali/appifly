module BookingHelper
  def business_class_flight_cost
    @flight_selected.cost * multiplier["Business"]
  end

  def first_class_flight_cost
    @flight_selected.cost * multiplier["First"]
  end

  def unit_flight_cost
    if @booking.passengers.count > 0
      "$ #{@booking.total_cost / @booking.passengers.count} per person"
    else
      "Invalid Booking Pending Addition of Passenger Details"
    end
  end
end
