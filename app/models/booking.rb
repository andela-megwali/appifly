class Booking < ActiveRecord::Base
  has_many :passengers, dependent: :destroy
  has_one :payment
  belongs_to :flight
  belongs_to :user
  after_create :update_booking_details

  accepts_nested_attributes_for :passengers, allow_destroy: true
  validates_presence_of :travel_class
  validates_associated :passengers

  def self.past_bookings(user_id)
    Booking.where(user_id: user_id)
  end

  private

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

  def update_booking_details
    update_attributes(reference_id: booking_ref_generator)
    send_booking_notification
  end
end
