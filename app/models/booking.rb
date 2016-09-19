class Booking < ActiveRecord::Base
  has_many :passengers
  #has_one :payment
  belongs_to :flight
  belongs_to :user

  accepts_nested_attributes_for :passengers
end
