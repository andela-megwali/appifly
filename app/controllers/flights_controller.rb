class FlightsController < ApplicationController
  include Concerns::MessagesHelper

  before_action :verify_admin_login, except: [:index, :show]
  before_action :verify_user_login
  before_action :set_flight, only: [:show, :edit, :update, :destroy]
  before_action :list_airport, only: [:new, :edit]

  def index
    @flights = Flight.reverse_sorted.paginate(page: params[:page], per_page: 30)
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
    if @flight.save
      redirect_to @flight, notice: flight_created_message
    else
      render :new
    end
  end

  def update
    if @flight.update(flight_params)
      redirect_to @flight, notice: flight_updated_message
    else
      render :edit
    end
  end

  def destroy
    @flight.destroy
    redirect_to flights_url, notice: flight_removed_message
  end

  private

  def set_flight
    @flight = Flight.find(params[:id])
  end

  def flight_params
    params.require(:flight).permit(
      :origin,
      :destination,
      :seat,
      :cost,
      :arrival,
      :airline,
      :code,
      :departure,
      :status
    )
  end
end
