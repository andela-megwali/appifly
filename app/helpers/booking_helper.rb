module BookingHelper
  def multiplier
    { "Economy" => 1, "Business" => 1.5, "First" => 2 }
  end

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

  def booking_travel_class
    if @passenger_enquiry
      @passenger_enquiry["class_selected"]
    else
      @booking.travel_class
    end
  end

  def booking_passenger_count
    if @passenger_enquiry
      @passenger_enquiry["number_travelling"]
    else
      @booking.passengers.count
    end
  end
end
