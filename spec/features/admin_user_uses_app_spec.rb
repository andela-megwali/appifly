require "rails_helper"

RSpec.feature "AdminUserUsesApp", type: :feature do
  before { create :user, :admin }

  scenario "Admin signs in with invalid credentials" do
    visit login_path
    fill_in("Username", with: "John")
    fill_in("Password", with: "1234567")
    click_on("Sign In")
    expect(page).to have_content("Invalid password or username")
    expect(page).to have_content("Log in")
    expect(page).to_not have_content("Welcome John")
    expect(page.current_path).to eq login_path
  end

  scenario "Admin signs in" do
    visit login_path
    sign_in
    expect(page).to have_content("User successfully signed in")
    expect(page).to have_content("Signed in as John **")
    expect(page).to have_content("Welcome John")
    expect(page.current_path).to eq past_bookings_path
  end

  scenario "Admin views flights list" do
    admin_lists_flights
    expect(page).to have_content("Listing Flights")
    expect(page).to have_content("Lagos (LOS)")
    expect(page).to_not have_content("Cancelled")
    expect(page).to have_content("Show")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Remove")
    expect(page.current_path).to eq flights_path
  end

  scenario "Admin tries to edit a flight" do
    admin_lists_flights
    click_on("Edit")
    expect(page).to have_content("Signed in as John **")
    expect(page).to have_content("Editing Flight")
    expect(page.current_path).to eq edit_flight_path(1)
  end

  scenario "Admin updates a flight" do
    admin_lists_flights
    click_on("Edit")
    fill_in("Seats", with: 215)
    click_on("Update Flight")
    expect(page).to have_content("Signed in as John **")
    expect(page).to have_content("Flight was successfully updated.")
    expect(page).to have_content("Seat: 215")
    expect(page.current_path).to eq flight_path(1)
  end

  scenario "Admin cancels a flight" do
    admin_lists_flights
    click_on("Edit")
    select("Cancelled", from: "Cancel This Flight?")
    click_on("Update Flight")
    expect(page).to have_content("Flight was successfully updated.")
    expect(page.current_path).to eq flight_path(1)
    expect(page).to have_content("Flight Status: Cancelled")

    visit flights_path
    expect(page).to have_content("Cancelled")
  end

  scenario "Admin removes a flight" do
    admin_lists_flights
    click_on("Remove")
    expect(page).to have_content("Flight CA112 has been removed.")
    expect(page.current_path).to eq flights_path
    expect(page).to_not have_content("Lagos (LOS)")
  end

  scenario "Admin tries to create new flight" do
    admin_lists_flights
    click_on("Create A New Flight")
    expect(page).to have_content("New Flight")
    expect(page.current_path).to eq new_flight_path
  end

  scenario "Admin creates new flight" do
    admin_lists_flights
    admin_creates_a_new_flight
    expect(page).to have_content("Flight was successfully created.")
    expect(page.current_path).to eq flight_path(2)
  end

  scenario "Admin views airport list" do
    admin_lists_airports
    expect(page).to have_content("Listing Airports")
    expect(page).to have_content("Lagos (LOS)")
    expect(page).to have_content("Murtala Mohammad Airport")
    expect(page).to have_content("Show")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Remove")
    expect(page.current_path).to eq airports_path
  end

  scenario "Admin tries to edit an airport" do
    admin_lists_airports
    first(:link, "Edit").click
    expect(page).to have_content("Editing Airport")
    expect(page.current_path).to eq edit_airport_path(1)
  end

  scenario "Admin updates an airport" do
    admin_lists_airports
    first(:link, "Edit").click
    fill_in("Name", with: "Merry")
    click_on("Update Airport")
    expect(page).to have_content("Merry Airport has been updated.")
    expect(page.current_path).to eq airport_path(1)
  end

  scenario "Admin deregisters an airport" do
    admin_lists_airports
    first(:link, "Remove").click
    expect(page).to have_content("Murtala Mohammad Airport has been removed")
    expect(page).to_not have_content("Lagos (LOS)")
    expect(page.current_path).to eq airports_path
  end

  scenario "Admin tries to create new airport" do
    admin_lists_airports
    click_on("Create New Airport")
    expect(page).to have_content("New Airport")
    expect(page.current_path).to eq new_airport_path
  end

  scenario "Admin creates new airport" do
    admin_lists_airports
    admin_creates_a_new_airport
    expect(page).to have_content("Warri Airport has been created")
    expect(page.current_path).to eq airport_path(3)
  end

  scenario "Admin views all bookings" do
    admin_lists_bookings
    expect(page).to have_content("Welcome John")
    expect(page).to have_content("Manage Your Bookings Here")
    expect(page).to have_content("111")
    expect(page).to have_content("Show")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Cancel")
    expect(page.current_path).to eq bookings_path
  end

  scenario "Admin cancels a booking" do
    admin_lists_bookings
    click_on("Cancel")
    expect(page).to have_content("Booking was successfully Cancelled")
    expect(page).to_not have_content("111")
    expect(page.current_path).to eq past_bookings_path
  end

  scenario "Admin views all users" do
    visit login_path
    sign_in
    visit users_path
    expect(page).to have_content("Listing Users")
    expect(page).to have_content("Show")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Remove")
    expect(page.current_path).to eq users_path
  end
end
