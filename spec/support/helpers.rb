module Helpers
  module UsersHelper
    def sign_up
      visit root_path
      click_on "Sign up"
      fill_in("Title", with: "Mr")
      fill_in("Firstname", with: "John")
      fill_in("Lastname", with: "Smith")
      fill_in("Email", with: "John@smith.com")
      fill_in("Password", with: "asdfghj")
      fill_in("Telephone", with: "1234567890")
      fill_in("Username", with: "John")
      check("Subscription")
      click_on("Create User")
    end

    def sign_in
      fill_in("Username", with: "John")
      fill_in("Password", with: "asdfghj")
      click_on("Sign In")
    end

    def search_for_flights
      create_list(:flight, 1)
      visit root_path
      select("Lagos (LOS)", from: "Travelling From")
      select("Abuja (ABV)", from: "Travelling To")
      fill_in("Earliest Departure Date", with: "10/15/2015")
      select("1", from: "Number of Passengers")
      select("Business", from: "Travel class")
      click_on("Find Flights")
    end

    def select_a_flight
      choose("select_flight_1")
      click_on("Select Flight")
    end

    def create_a_booking
      select_a_flight
      fill_in("Title", with: "Mr")
      fill_in("Firstname", with: "John")
      fill_in("Lastname", with: "Smith")
      fill_in("Email", with: "John@smith.com")
      fill_in("Telephone", with: "1234567890")
      fill_in("Nationality", with: "Indian")
      click_on("Create Booking")
    end

    def booking_just_created
      sign_in
      search_for_flights
      create_a_booking
    end

    def manage_past_bookings
      booking_just_created
      click_on("Manage Bookings")
    end

    def find_booking_info
      search_for_flights
      create_a_booking
      click_on("Find Your Booking")
    end

    def admin_searches_for_flight
      visit login_path
      sign_in
      search_for_flights
    end

    def admin_lists_flights
      admin_searches_for_flight
      visit flights_path
    end

    def admin_creates_a_new_flight
      click_on("Create A New Flight")
      select("Abuja (ABV)", from: "flight_origin")
      select("Lagos (LOS)", from: "flight_destination")
      fill_in("Seats", with: 230)
      select("17", from: "flight_departure_4i")
      select("18", from: "flight_arrival_4i")
      fill_in("Airline", with: "Chinese Airlines")
      fill_in("Code", with: "CA111")
      click_on("Create Flight")
    end

    def admin_creates_a_new_airport
      click_on("Create New Airport")
      fill_in("Name", with: "Warri")
      fill_in("Jurisdiction", with: "Local")
      fill_in("State and code", with: "Delta (QRW)")
      fill_in("Country", with: "Nigeria")
      fill_in("Continent", with: "Africa")
      fill_in("Rating", with: "7")
      click_on("Create Airport")
    end

    def admin_lists_airports
      admin_searches_for_flight
      visit airports_path
    end

    def admin_lists_bookings
      admin_searches_for_flight
      create_a_booking
      visit bookings_path
    end
  end
end
