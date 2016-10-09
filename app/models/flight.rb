class Flight < ActiveRecord::Base
  has_many :bookings, dependent: :destroy
  belongs_to :airport
  before_save :additional_flight_details
  validates_presence_of :seat, :departure, :arrival, :airline, :code

  scope :sorted, lambda { order("flights.departure ASC") }

  def self.search(from, to, time_now, departure_time, bookable)
    where("origin = ? AND destination = ? AND departure >= ? "\
          "AND departure >= ? AND status = ?",
          from,
          to,
          time_now,
          departure_time,
          bookable).sorted
  end

  private

  def airport_info
    {
      fly_from: Airport.find_by(state_and_code: origin),
      fly_to: Airport.find_by(state_and_code: destination),
    }
  end

  def get_flight_origin
    self.airport_id = airport_info[:fly_from].id
    self.origin = airport_info[:fly_from].state_and_code
  end

  def get_flight_type
    if airport_info[:fly_from].country == airport_info[:fly_to].country
      "Local"
    elsif airport_info[:fly_from].continent == airport_info[:fly_to].continent
      "Continental"
    else
      "International"
    end
  end

  def get_flight_cost
    if get_flight_type == "Local"
      rand(150..250)
    elsif get_flight_type == "Continental"
      rand(350..600)
    else
      rand(750..1250)
    end
  end

  def get_flight_status
    if status == "Yes"
      "Cancelled"
    elsif departure > Time.now
      "Booking"
    else
      "Past"
    end
  end

  def additional_flight_details
    get_flight_origin
    self.jurisdiction = get_flight_type
    self.status = get_flight_status
    self.cost = get_flight_cost unless cost
  end
end
