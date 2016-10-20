FactoryGirl.define do
  factory :airport do
    name "Murtala Mohammad Airport"
    continent "Africa"
    country "Nigeria"
    state_and_code "Lagos (LOS)"
    jurisdiction "International"
    rating 10

    trait(:abuja_airport) do
      state_and_code "Abuja (ABV)"
    end

    trait(:nairobi_airport) do
      state_and_code "Nairobi (NBO)"
      country "Kenya"
    end

    trait(:jfk_airport) do
      state_and_code "New York (JFK)"
      country "United States"
      continent "North America"
    end
  end
end
