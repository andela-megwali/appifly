class AirportsController < ApplicationController
  before_action :set_airport, only: [:show, :edit, :update, :destroy]
  before_action :verify_user_login

  def index
    @airports = Airport.all.paginate(page: params[:page], per_page: 30)
  end

  def new
    @airport = Airport.new
  end

  def create
    @airport = Airport.new(airport_params)
    if @airport.save
      redirect_to @airport, notice: "#{@airport.name} Airport has been created."
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
      redirect_to @airport, notice: "#{@airport.name} Airport has been updated."
    else
      render :edit
    end
  end

  def destroy
    @airport.destroy
    redirect_to airports_url, notice: "#{@airport.name} has been removed"
  end

  private

  def set_airport
    @airport = Airport.find_by(id: params[:id])
  end

  def airport_params
    params.require(:airport).permit(:name,
                                    :continent,
                                    :country,
                                    :jurisdiction,
                                    :state_and_code,
                                    :rating)
  end
end
