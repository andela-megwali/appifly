class User < ActiveRecord::Base
  has_secure_password
  has_many :bookings
  validates_presence_of :firstname, :lastname, :email, :username, :password
end
