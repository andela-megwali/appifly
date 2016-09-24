class Airport < ActiveRecord::Base
  has_many :flights
  scope :state_code, lambda { |from|
    where("state_and_code LIKE ?", "%#{from}%")
  }
end
