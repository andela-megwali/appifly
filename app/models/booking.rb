class Booking < ActiveRecord::Base
  has_many :passengers
  has_one :payment
  belongs_to :flight
  belongs_to :user

  accepts_nested_attributes_for :passengers, allow_destroy: true
  #reject_if: lambda {|attributes| attributes['firstname'].blank?}, 
  validates_associated :passengers
end
