class Flight < ActiveRecord::Base
  has_many :bookings, dependent: :destroy
  belongs_to :airport
  scope :search_flight, lambda { |from, to, time_now, departure_time, bookable|
    where("origin LIKE ? AND destination LIKE ? AND departure >= ?
          AND departure >= ? AND status = ?",
          "%#{from}%",
          "%#{to}%",
          time_now,
          departure_time,
          bookable)
  }
  scope :sorted, lambda { order("flights.departure ASC") }
end
