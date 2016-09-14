class Booking < ActiveRecord::Base
  has_many :passengers
  #has_one :payment
  belongs_to :flight
  belongs_to :user
end
