class Flight < ActiveRecord::Base
  has_many :bookings
  belongs_to :airline
  scope :search_flight, lambda { |from, to, time_now, departure_time| where(
    "origin LIKE ? AND destination LIKE ? AND departure >= ? AND departure >= ?",
        "%#{from}%",
        "%#{to}%",
        time_now,
        departure_time,
  ) }
  scope :sorted, lambda { order("flights.departure ASC") }
end
