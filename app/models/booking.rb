class Booking < ActiveRecord::Base
  has_many :passengers, dependent: :destroy
  has_one :payment
  belongs_to :flight
  belongs_to :user
  after_create :update_booking_details

  accepts_nested_attributes_for :passengers, allow_destroy: true
  validates_associated :passengers

  private

  def booking_ref_generator
    flight.code + "-" + rand(1000..9999).to_s + "-" + rand(1000..9999).to_s + "-" + rand(1000..9999).to_s + "-" + flight_id.to_s + passengers.count.to_s + id.to_s

# [flight.code, rand(1000..9999).to_s, rand(1000..9999).to_s,
# rand(1000..9999).to_s, %Q(#{flight_id.to_s} #{passengers.size.to_s} #{@id.to_s})].join "-"
  end

  def cost_calculator
    # use multiplier constant and set it in the config/initializers
    multiplier = { "Economy" => 1, "Business" => 1.5, "First" => 2 }
    travel_value = multiplier[travel_class] * passengers.count
    travel_value * flight.cost
  end

  def send_booking_notification
    passengers.each do |passenger|
      Notifications.booking_confirmation(passenger).deliver_later
    end
  end

  def update_booking_details
    update_attributes(reference_id: booking_ref_generator, total_cost: cost_calculator)
    send_booking_notification
  end
end
