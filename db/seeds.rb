# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Airport.create(name: "Murtala Muhammed",
               continent: "Africa",
               country: "Nigeria",
               state_and_code: "Lagos (LOS)",
               jurisdiction: "International",
               rating: 8)

Airport.create(name: "Nnamdi Azikiwe",
               continent: "Africa",
               country: "Nigeria",
               state_and_code: "Abuja (ABV)",
               jurisdiction: "International",
               rating: 8)

Airport.create(name: "Warri",
               continent: "Africa",
               country: "Nigeria",
               state_and_code: "Delta (QRW)",
               jurisdiction: "Local",
               rating: 7)

Airport.create(name: "Jomo Kenyatta",
               continent: "Africa",
               country: "Kenya",
               state_and_code: "Nairobi (NBO)",
               jurisdiction: "International",
               rating: 7)

Airport.create(name: "Eldoret",
               continent: "Africa",
               country: "Kenya",
               state_and_code: "Eldoret (EDL)",
               jurisdiction: "International",
               rating: 7)

Airport.create(name: "Idlewild",
               continent: "North America",
               country: "United States",
               state_and_code: "New York (IDL)",
               jurisdiction: "International",
               rating: 8)

Airport.create(name: "John F Kennedy",
               continent: "North America",
               country: "United States",
               state_and_code: "New York (JFK)",
               jurisdiction: "International",
               rating: 9)

airport_codes = []
Airport.all.each { |airport| airport_codes << airport.state_and_code }

airline_list = [
                 ["Chinese Airlines", "CA#{rand(100..999)}"],
                 ["Makinwa Flies Monthly", "MFM#{rand(100..999)}"],
                 ["Arik Air", "AA#{rand(100..999)}"],
                 ["Virgin Nigeria", "VN#{rand(100..999)}"],
                 ["Kenya Airways", "KA#{rand(100..999)}"],
                 ["KLM", "KLM#{rand(100..999)}"],
                 ["Air France", "AF#{rand(100..999)}"],
                 ["British Airways", "BA#{rand(100..999)}"],
                 ["Imagine Nation", "IN#{rand(100..999)}"],
                 ["Happy Flights", "HF#{rand(100..999)}"],
                 ["On Air", "OA#{rand(100..999)}"],
               ]
status_list = ["Booking", "Booking", "Cancelled", "Booking"]

750.times do
  f_departure = Time.now + (rand 90).days
  f_arrival = f_departure + (rand 11).hours + (rand 59).minutes
  f_airline = airline_list[rand airline_list.count]
  f_status = status_list[rand status_list.count]
  f_origin = airport_codes[rand airport_codes.count]
  f_destination = airport_codes[rand airport_codes.count]
  
  while f_destination == f_origin
    f_destination = airport_codes[rand airport_codes.count]
  end

  Flight.create(origin: f_origin,
                destination: f_destination,
                seat: rand(100..250),
                departure: f_departure,
                arrival: f_arrival,
                airline: f_airline[0],
                code: f_airline[1],
                status: f_status)
end
