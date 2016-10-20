require "rails_helper"

RSpec.feature "AnonymousUser", type: :feature do
  scenario "User searches for flights" do
    search_for_flights
    expect(page).to have_content("Available Flights")
    expect(page).to have_content("Results found: 1")
    expect(page).to have_content("Select Flight")
    expect(page.current_path).to eq root_path
  end

  scenario "User selects a Flight" do
    search_for_flights
    select_a_flight
    expect(page).to have_content("You are not signed in")
    expect(page).to have_content("Now Booking")
    expect(page).to have_content("Enter Your Booking Information")
    expect(page.current_path).to eq new_booking_path
  end

  scenario "User creates a booking" do
    search_for_flights
    create_a_booking
    expect(page).to have_content("Booking was successfully created")
    expect(page).to have_content("111")
    expect(page).to have_content("Firstname: John")
    expect(page).to_not have_content("Editing Booking")
    expect(page).to_not have_content("Manage Bookings")
    expect(page.current_path).to eq booking_path(1)
  end

  scenario "User searches for booking via reference id" do
    find_booking_info
    expect(page).to have_content("Find Your Booking Information")
    expect(page).to have_content("Enter Your Booking Reference Number")
    expect(page.current_path).to eq search_booking_path
  end

  scenario "User finds booking via reference id" do
    find_booking_info
    fill_in("reference_id", with: Booking.first.reference_id.to_s)
    click_on("Get Booking Details")
    expect(page).to have_content("Booking Found")
    expect(page).to have_content("Booking Details")
    expect(page).to have_content("Destination: Abuja (ABV)")
    expect(page).to have_content("111")
    expect(page.current_path).to eq booking_path(1)
  end

  scenario "User tries invalid booking reference id" do
    find_booking_info
    fill_in("reference_id", with: "Qwer1234767")
    click_on("Get Booking Details")
    expect(page).to have_content("Booking Not Found")
    expect(page).to have_content("Find Your Booking Information")
    expect(page).to have_content("Enter Your Booking Reference Number")
    expect(page.current_path).to eq search_booking_path
  end

  scenario "User attempts hack to edit booking" do
    search_for_flights
    create_a_booking
    visit edit_booking_path(1)
    expect(page).to have_content("There's more but please sign in first :)")
    expect(page).to have_content("Log in")
    expect(page.current_path).to eq login_path
  end

  scenario "User attempts hack to manage past booking" do
    search_for_flights
    create_a_booking
    visit past_bookings_path
    expect(page).to have_content("There's more but please sign in first :)")
    expect(page).to have_content("Log in")
    expect(page.current_path).to eq login_path
  end

  scenario "User attempts hack to view flights list" do
    search_for_flights
    create_a_booking
    visit flights_path
    expect(page).to have_content("There's more but please sign in first :)")
    expect(page).to have_content("Log in")
    expect(page.current_path).to eq login_path
  end
end
