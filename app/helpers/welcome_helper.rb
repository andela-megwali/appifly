module WelcomeHelper
  def multiplier
    { "Economy" => 1, "Business" => 1.5, "First" => 2 }
  end

  def search_result_display_format
    if @enquire && params[:view_format] == "Grid"
      render "search2"
    elsif @enquire || params[:view_format] == "List"
      render "search"
    end
  end

  def passenger_class
    if multiplier.key? @passenger_enquiry[:class_selected]
      @passenger_enquiry[:class_selected]
    else
      "Economy"
    end
  end

  def travel_value
    multiplier[passenger_class] || 1
  end

  def flight_cost(flight)
    flight.cost * travel_value
  end

  def total_flight_cost(flight)
    @passenger_enquiry[:number_travelling] * flight_cost(flight)
  end
end
