class Airline < ActiveRecord::Base
  has_many :flights
  belongs_to :airport
end
