class Booking < ActiveRecord::Base
  has_many :passengers, dependent: :destroy
  has_one :payment
  belongs_to :flight
  belongs_to :user
  after_create :set_booking_reference_and_cost
  after_update :set_total_cost

  accepts_nested_attributes_for :passengers, allow_destroy: true
  validates_presence_of :travel_class
  validates_associated :passengers

  def self.past_bookings(user_id)
    Booking.where(user_id: user_id)
  end

  private

  def cost_calculator
    multiplier = { "Economy" => 1, "Business" => 1.5, "First" => 2 }
    travel_value = multiplier[travel_class] * passengers.size
    travel_value * flight.cost
  end

  def booking_ref_generator
    [
      flight.code,
      rand(1000..9999).to_s,
      rand(1000..9999).to_s,
      rand(1000..9999).to_s,
      "#{flight_id}#{passengers.size}#{id}"
    ].join "-"
  end

  def send_booking_notification
    passengers.each do |passenger|
      Notifications.booking_confirmation(passenger).deliver_later
    end
  end

  def set_booking_reference_and_cost
    update_attributes(
      reference_id: booking_ref_generator,
      total_cost: cost_calculator
    )
    send_booking_notification
  end

  def set_total_cost
    if total_cost != cost_calculator
      update_attributes(total_cost: cost_calculator)
      send_booking_notification
    end
  end
end
