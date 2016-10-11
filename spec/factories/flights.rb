FactoryGirl.define do
  factory :flight do
    origin { create(:airport).state_and_code }
    destination { create(:airport, :abuja_airport).state_and_code }
    seat 200
    arrival Time.now + 5.days + 50.minutes
    airline "Chinese Airways"
    code "CA112"
    departure Time.now + 5.days
    status "Booking"

    trait(:nairobi_flight) do
      destination { create(:airport, :nairobi_airport).state_and_code }
    end

    trait(:jfk_flight) do
      destination { create(:airport, :jfk_airport).state_and_code }
    end
  end
end
