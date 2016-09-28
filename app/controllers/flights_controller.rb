class FlightsController < ApplicationController
  before_action :verify_user_login
  before_action :set_flight, only: [:show, :edit, :update, :destroy]
  before_action :list_airport, only: [:new, :edit]

  def index
    @flights = Flight.all.paginate(page: params[:page], per_page: 30)
  end

  def show
  end

  def new
    @flight = Flight.new
  end

  def edit
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

  def additional_flight_details
    get_flight_origin
    @flight.flight_type = get_flight_type
    @flight.status = get_flight_status
    @flight.save
  end
end
