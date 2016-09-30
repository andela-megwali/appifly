class Flight < ActiveRecord::Base
  has_many :bookings, dependent: :destroy
  belongs_to :airport
  before_save :additional_flight_details

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

  def additional_flight_details
    get_flight_origin
    self.jurisdiction = get_flight_type
    self.status = get_flight_status
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

  def get_flight_status
    if status == "Yes"
      "Cancelled"
    elsif departure > Time.now
      "Booking"
    else
      "Past"
    end
  end
end
