class AirportsController < ApplicationController
  before_action :set_airport, only: [:show, :edit, :update, :destroy]

  def index
    @airports = Airport.all
  end

  def new
    @airport = Airport.new
  end

  def create
    @airport = Airport.new(airport_params)
    if @airport.save
      redirect_to @airport, notice: "Airport was successfully created."
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @airport.update(airport_params)
      redirect_to @airport, notice: "Airport was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @airport.destroy
    redirect_to airports_url, notice: "#{@airport.name + ' ' +
                                      @airport.airport_type} Airport has been
                                      removed"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_airport
    @airport = Airport.find(params[:id])
  end

  # Never trust parameters from the internet, only allow the white list through.
  def airport_params
    params.require(:airport).permit :name, :continent, :country, :airport_type,
                                    :state_and_code, :rating
  end
end
