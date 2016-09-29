class Booking < ActiveRecord::Base
  has_many :passengers, dependent: :destroy
  has_one :payment
  belongs_to :flight
  belongs_to :user

  accepts_nested_attributes_for :passengers, allow_destroy: true
  validates_associated :passengers
end
