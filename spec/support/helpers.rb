module Helpers
  module UsersHelper
    def sign_up
      visit root_path
      click_on "Sign up"
      fill_in("Title", with: "Mr")
      fill_in("Firstname", with: "John")
      fill_in("Lastname", with: "Smith")
      fill_in("Email", with: "John@smith.com")
      fill_in("Password", with: "1234567")
      fill_in("Telephone", with: "1234567890")
      fill_in("Username", with: "John")
      check("Subscription")
      click_on("Create User")
    end

    def sign_in
      sign_up
      fill_in("Username", with: "John")
      fill_in("Password", with: "1234567")
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

    def create_a_booking
      choose("select_flight_1")
      click_on("Select Flight")
      fill_in("Title", with: "Mr")
      fill_in("Firstname", with: "John")
      fill_in("Lastname", with: "Smith")
      fill_in("Email", with: "John@smith.com")
      fill_in("Telephone", with: "1234567890")
      fill_in("Nationality", with: "Indian")
      click_on("Create Booking")
    end
  end
end
