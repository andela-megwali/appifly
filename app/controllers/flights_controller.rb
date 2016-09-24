class FlightsController < ApplicationController
  before_action :set_flight, only: [:show, :edit, :update, :destroy]

  def index
    @flights = Flight.all
  end

  def show
  end

  def new
    @flight = Flight.new
    list_airport
  end

  def edit
    list_airport
  end

  def create
    @flight = Flight.new(flight_params)
    additional_flight_details
    if @flight.save
      redirect_to @flight, notice: "Flight was successfully created."
    else
      render :new
    end
  end

  def update
    if @flight.update(flight_params)
      additional_flight_details
      redirect_to @flight, notice: "Flight was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @flight.destroy
    redirect_to flights_url, notice: "Flight #{@flight.flight_code} has been
                                      removed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_flight
    @flight = Flight.find(params[:id])
  end

  # Never trust parameters from the internet, only allow the whitelist through
  def flight_params
    params.require(:flight).permit :origin, :destination, :seat, :flight_cost,
                                   :arrival, :airline, :flight_code, :departure,
                                   :status
  end

  def airport_info
    {
      "fly_from" => Airport.find_by(state_and_code: params[:flight][:origin]),
      "fly_to" => Airport.find_by(state_and_code: params[:flight][:destination])
      # "fly_from" => Airport.state_code(params[:flight][:origin]).first,
      # "fly_to" => Airport.state_code(params[:flight][:destination]).first,
    }
  end

  def get_flight_origin
    @flight.airport_id = airport_info["fly_from"].id
    @flight.origin = airport_info["fly_from"].state_and_code
  end

  def get_flight_type
    if airport_info["fly_from"].country == airport_info["fly_to"].country
      "Local"
    elsif airport_info["fly_from"].continent == airport_info["fly_to"].continent
      "Continental"
    else
      "International"
    end
  end

  def get_flight_status
    if params[:flight][:status] == "Yes"
      "Cancelled"
    elsif @flight.departure > Time.now
      "Booking"
    elsif @flight.departure < Time.now && Time.now < @flight.arrival
      "In Transit"
    else
      "Past"
    end
  end

  def list_airport
    list_of_airport = []
    Airport.all.each do |airport|
      list_of_airport << airport.state_and_code
    end
    @list_airport = list_of_airport
  end

  def additional_flight_details
    get_flight_origin
    @flight.flight_type = get_flight_type
    @flight.status = get_flight_status
    @flight.save
  end
end
