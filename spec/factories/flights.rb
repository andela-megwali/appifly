FactoryGirl.define do
  factory :flight do
    origin "Lagos (LOS)"
    destination "Abuja (ABV)"
    seat 200
    cost 230
    arrival Time.now + 5.days + 50.minutes
    airline "Chinese Airways"
    code "CA112"
    departure Time.now + 5.days
    status "Booking"
  end
end
