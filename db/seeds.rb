# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Flight.create(origin: "ABV", destination: "LOS", seat: 250, departure: Time.now + 5.days, arrival: Time.now + 5.days + 50.minutes, airplane: "Boeing 747", flight_code: "MFM12", flight_type: "Local", flight_cost: 200, airline_id: 1)
Flight.create(origin: "LOS", destination: "NBO", seat: 250, departure: Time.now + 4.days, arrival: Time.now + 4.days + 2.hours + 50.minutes, airplane: "Boeing 747", flight_code: "MFM24", flight_type: "Continental", flight_cost: 500, airline_id: 1)
Flight.create(origin: "LOS", destination: "NYC", seat: 250, departure: Time.now + 5.days, arrival: Time.now + 5.days + 8.hours, airplane: "Boeing 747", flight_code: "MFM27", flight_type: "International", flight_cost: 900, airline_id: 1)
Flight.create(origin: "NYC", destination: "NBO", seat: 250, departure: Time.now + 3.days, arrival: Time.now + 3.days + 6.hours, airplane: "Boeing 747", flight_code: "MFM23", flight_type: "International", flight_cost: 900, airline_id: 1)
Flight.create(origin: "NBO", destination: "LOS", seat: 250, departure: Time.now + 5.days, arrival: Time.now + 5.days + 3.hours, airplane: "Boeing 747", flight_code: "MFM24", flight_type: "Continental", flight_cost: 500, airline_id: 1)

Airline.create(name: "Makinwa Flies Monthly", airline_code: "MFM", rating: 8)

airport_codes = ["ABV", "LOS", "NBO", "NYC"]
airport_codes[rand airport_codes.count]
