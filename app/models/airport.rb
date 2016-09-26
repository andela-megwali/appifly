class Airport < ActiveRecord::Base
  has_many :flights, :dependent => :destroy
end
