require "rails_helper"

RSpec.describe BookingHelper, type: :helper do
  describe "#booking_passenger_count" do
    context "when booking has not been created" do
      it "sets the passenger count" do
        @passenger_enquiry = { "number_travelling" => 2 }
        expect(booking_passenger_count).to eq 2
      end
    end

    context "when booking has been created" do
      before do
        create :flight
        create :booking
      end

      it "sets the passenger count" do
        @booking = Booking.first
        expect(booking_passenger_count).to eq 1
      end
    end
  end

  describe "#booking_travel_class" do
    context "when booking has not been created" do
      it "sets the travel class" do
        @passenger_enquiry = { "class_selected" => "Business" }
        expect(booking_travel_class).to eq "Business"
      end
    end

    context "when booking has been created" do
      before do
        create :flight
        create :booking
      end

      it "sets the travel class" do
        @booking = Booking.first
        expect(booking_travel_class).to eq "Economy"
      end
    end
  end

  describe "#unit_flight_cost" do
    context "when passengers have been booked" do
      before do
        create :flight, cost: 300
        create :booking
      end

      it "sets unit flight cost" do
        @booking = Booking.first
        expect(unit_flight_cost).to eq "$ 300 per person"
      end
    end

    context "when passengers have not been booked" do
      before do
        create :flight, cost: 300
        create :booking
        c = Booking.first
        c.passengers.first.destroy
      end

      it "sets unit flight cost" do
        @booking = Booking.first
        expect(unit_flight_cost).to eq "Invalid Booking Pending Addition of "\
                                       "Passenger Details"
      end
    end
  end

  describe "set flight cost" do
    before do
      create :flight, cost: 300
      create :booking
    end

    context "when business class is selected" do
      it "runs business_class_flight_cost" do
        @flight_selected = Flight.find(1)
        expect(business_class_flight_cost).to eq 450
      end
    end

    context "when first class is selected" do
      it "runs first_class_flight_cost" do
        @flight_selected = Flight.find(1)
        expect(first_class_flight_cost).to eq 600
      end
    end
  end
end
