# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

  Airport.create(name: "Murtala Muhammed", continent: "Africa", country: "Nigeria", state_and_code: "Lagos (LOS)", jurisdiction: "International", rating: 8)
  Airport.create(name: "Nnamdi Azikiwe", continent: "Africa", country: "Nigeria", state_and_code: "Abuja (ABV)", jurisdiction: "International", rating: 8)
  Airport.create(name: "Warri", continent: "Africa", country: "Nigeria", state_and_code: "Delta (QRW)", jurisdiction: "Local", rating: 7)
  Airport.create(name: "Jomo Kenyatta", continent: "Africa", country: "Kenya", state_and_code: "Nairobi (NBO)", jurisdiction: "International", rating: 7)
  Airport.create(name: "Eldoret", continent: "Africa", country: "Kenya", state_and_code: "Eldoret (EDL)", jurisdiction: "International", rating: 7)
  Airport.create(name: "Idlewild", continent: "North America", country: "United States", state_and_code: "New York (IDL)", jurisdiction: "International", rating: 8)
  Airport.create(name: "John F Kennedy", continent: "North America", country: "United States", state_and_code: "New York (JFK)", jurisdiction: "International", rating: 9)

airport_codes =[]
Airport.all.each {|airport| airport_codes << airport.state_and_code}

# airline_list = [["Chinese Airlines", "CA123"], ["Makinwa Flies Monthly", "MFM234"], ["Arik Air", "AA178"], "Virgin Nigeria", "Kenya Airways", "KLM", "Air France", "British Airways", "Mic on Air", "Happy Flights"]


# c = airline_list[rand airline_list.count]
# c[0]
# c[1]

100.times {
Flight.create(origin: "#{airport_codes[rand airport_codes.count]}", destination: "#{airport_codes[rand airport_codes.count]}", seat: 250, departure: Time.now + 5.days, arrival: Time.now + 5.days + 50.minutes, airline: "Chinese Airlines", code: "MFM12", jurisdiction: "Local", cost: 200, status: "Booking")
Flight.create(origin: "#{airport_codes[rand airport_codes.count]}", destination: "#{airport_codes[rand airport_codes.count]}", seat: 250, departure: Time.now + 4.days, arrival: Time.now + 4.days + 2.hours + 50.minutes, airline: "Makinwa Flies Monthly", code: "MFM24", jurisdiction: "Continental", cost: 500, status: "Booking")
Flight.create(origin: "#{airport_codes[rand airport_codes.count]}", destination: "#{airport_codes[rand airport_codes.count]}", seat: 250, departure: Time.now + 5.days, arrival: Time.now + 5.days + 8.hours, airline: "Arik Air", code: "MFM27", jurisdiction: "International", cost: 900, status: "Cancelled")
Flight.create(origin: "#{airport_codes[rand airport_codes.count]}", destination: "#{airport_codes[rand airport_codes.count]}", seat: 250, departure: Time.now + 3.days, arrival: Time.now + 3.days + 6.hours, airline: "Chinese Airlines", code: "MFM23", jurisdiction: "International", cost: 900, status: "Cancelled")
Flight.create(origin: "#{airport_codes[rand airport_codes.count]}", destination: "#{airport_codes[rand airport_codes.count]}", seat: 250, departure: Time.now + 5.days, arrival: Time.now + 5.days + 3.hours, airline: "Makinwa Flies Monthly", code: "MFM24", jurisdiction: "Continental", cost: 500, airport_id: 1)
}