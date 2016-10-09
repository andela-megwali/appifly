FactoryGirl.define do
  factory :booking do
    travel_class "Economy"
    reference_id "MFM1325364646"
    total_cost 300
    flight_id 1
    user_id 1
    passengers_attributes [id: "",
                           nationality: "Nigerian",
                           firstname: "Mary",
                           lastname: "Dan",
                           email: "m@s.com",
                           telephone: "1234567",
                           title: "Mrs",
                           luggage: "No",
                           _destroy: 0]
  end
end
