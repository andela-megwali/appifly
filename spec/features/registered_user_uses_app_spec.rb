require "rails_helper"

RSpec.feature "RegisteredUserUsesApp", type: :feature do
  scenario "User signs up" do
    sign_up
    expect(page).to have_content("Account created. Sign in to continue")
    expect(page.current_path).to eq login_path
  end

  scenario "User signs in" do
    sign_in
    expect(page).to have_content("User successfully signed in")
    expect(page).to have_content("Welcome John")
    expect(page.current_path).to eq past_bookings_path
  end

  scenario "User searches for flights" do
    sign_in
    search_for_flights
    expect(page).to have_content("Available Flights")
    expect(page).to have_content("Results found: 1")
    expect(page).to have_content("Select a Flight")
    expect(page.current_path).to eq root_path
  end

  scenario "User selects a Flight" do
    sign_in
    search_for_flights
    choose("select_flight_1")
    click_on("Select Flight")
    expect(page).to have_content("Now Booking")
    expect(page).to have_content("Enter Your Booking Information")
    expect(page).to have_content("Signed in as John")
    expect(page.current_path).to eq new_booking_path
  end

  scenario "User creates a booking" do
    sign_in
    search_for_flights
    create_a_booking
    expect(page).to have_content("Booking was successfully created")
    expect(page).to have_content("111")
    expect(page).to have_content("Firstname: John")
    expect(page.current_path).to eq booking_path(1)
  end

  scenario "User tries to edit booking" do
    sign_in
    search_for_flights
    create_a_booking
    click_on("Edit This Booking")
    expect(page).to have_content("Editing Booking")
    expect(page.current_path).to eq edit_booking_path(1)
  end

  scenario "User Updates booking" do
    sign_in
    search_for_flights
    create_a_booking
    click_on("Edit This Booking")
    fill_in("Firstname", with: "Joanna")
    click_on("Update Booking")
    expect(page).to have_content("Booking was successfully updated")
    expect(page).to have_content("111")
    expect(page).to have_content("Firstname: Joanna")
    expect(page.current_path).to eq booking_path(1)
  end

  scenario "User manages past booking" do
    sign_in
    search_for_flights
    create_a_booking
    click_on("Manage Bookings")
    expect(page).to have_content("Welcome John")
    expect(page).to have_content("Manage Your Bookings Here")
    expect(page).to have_content("Show")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Cancel")
    expect(page.current_path).to eq past_bookings_path
  end

  scenario "User cancels booking" do
    sign_in
    search_for_flights
    create_a_booking
    click_on("Manage Bookings")
    click_on("Cancel")
    expect(page).to have_content("Booking was successfully Cancelled")
    expect(page).to_not have_content("111")
    expect(page.current_path).to eq past_bookings_path
  end

  scenario "User searches for booking via reference id" do
    sign_in
    search_for_flights
    create_a_booking
    click_on("Find Your Booking")
    expect(page).to have_content("Find Your Booking Information")
    expect(page).to have_content("Enter Your Booking Reference Number")
    expect(page.current_path).to eq search_booking_path
  end

  scenario "User finds booking via reference id" do
    sign_in
    search_for_flights
    create_a_booking
    click_on("Find Your Booking")
    fill_in("reference_id", with: Booking.first.reference_id.to_s)
    click_on("Get Booking Details")
    expect(page).to have_content("Booking Found")
    expect(page).to have_content("Booking Details")
    expect(page).to have_content("Destination: Abuja (ABV)")
    expect(page).to have_content("111")
    expect(page.current_path).to eq booking_path(1)
  end

  scenario "User tries invalid booking reference id" do
    sign_in
    search_for_flights
    create_a_booking
    click_on("Find Your Booking")
    fill_in("reference_id", with: "Qwer1234767")
    click_on("Get Booking Details")
    expect(page).to have_content("Booking Not Found")
    expect(page).to have_content("Find Your Booking Information")
    expect(page).to have_content("Enter Your Booking Reference Number")
    expect(page.current_path).to eq search_booking_path
  end

  scenario "User views flights list" do
    sign_in
    search_for_flights
    create_a_booking
    visit flights_path
    expect(page).to have_content("Listing Flights")
    expect(page).to have_content("Flight code")
    expect(page).to have_content("Show")
    expect(page).to_not have_content("Edit")
    expect(page.current_path).to eq flights_path
  end

  scenario "User tries to hack any admin action" do
    sign_in
    search_for_flights
    create_a_booking
    visit edit_flight_path(1)
    expect(page).to have_content("Signed in as John")
    expect(page).to have_content("You are not authorized to access")
    expect(page.current_path).to eq root_path
  end
end
