class Airport < ActiveRecord::Base
  has_many :flights, dependent: :destroy
  validates_presence_of :name,
                        :continent,
                        :country,
                        :jurisdiction,
                        :state_and_code,
                        :rating
end
