class Passenger < ActiveRecord::Base
  belongs_to :booking
  validates_presence_of :firstname, :lastname, :email, :telephone, :nationality
end
