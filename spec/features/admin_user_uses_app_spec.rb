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
    visit login_path
    sign_in
    create_list(:flight, 1)
    visit flights_path
    expect(page).to have_content("Listing Flights")
    expect(page).to have_content("Flight code")
    expect(page).to have_content("Show")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Remove")
    expect(page.current_path).to eq flights_path
  end

  scenario "Admin tries to edit a flight" do
    visit login_path
    sign_in
    create_list(:flight, 1)
    visit flights_path
    click_on("Edit")
    expect(page).to have_content("Signed in as John **")
    expect(page).to have_content("Editing Flight")
    expect(page.current_path).to eq edit_flight_path(1)
  end

  scenario "Admin updates a flight" do
    visit login_path
    sign_in
    create_list(:flight, 1)
    visit flights_path
    click_on("Edit")
    fill_in("Seats", with: 215)
    click_on("Update Flight")
    expect(page).to have_content("Signed in as John **")
    expect(page).to have_content("Flight was successfully updated.")
    expect(page).to have_content("Seat: 215")
    expect(page.current_path).to eq flight_path(1)
  end

  scenario "Admin cancels a flight" do
    visit login_path
    sign_in
    create_list(:flight, 1)
    visit flights_path
    click_on("Edit")
    select("Cancelled", from: "Cancel This Flight?")
    click_on("Update Flight")
    expect(page).to have_content("Signed in as John **")
    expect(page).to have_content("Flight was successfully updated.")
    expect(page.current_path).to eq flight_path(1)
  end

  scenario "Admin views Airport list" do
    visit login_path
    sign_in
    create_list(:flight, 1)
    visit airports_path
    expect(page).to have_content("Listing Airports")
    expect(page).to have_content("Murtala Mohammad Airport")
    expect(page).to have_content("Show")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Remove")
    expect(page.current_path).to eq airports_path
  end
end
