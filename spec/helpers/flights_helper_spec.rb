require "rails_helper"

RSpec.describe FlightsHelper, type: :helper do
  before do
    create :flight, :transit_flight
    create :flight, :past_flight
  end

  describe "#flight_status_display" do
    context "when departure time has passed" do
      it "sets status as fly if flight has not arrived" do
        expect(flight_status_display(Flight.find(1))).to eq "Fly"
      end
      it "sets status as past if flight has arrived" do
        expect(flight_status_display(Flight.find(2))).to eq "Past"
      end
    end
  end

  describe "#index_for_pagination" do
    context "when no page number is available" do
      it "adjusts the pagination index to start from 1" do
        expect(index_for_pagination(0)).to eq 1
        expect(index_for_pagination(9)).to eq 10
      end
    end

    context "when no page number is available" do
      it "adjusts the pagination index to match page" do
        params[:page] = 2
        expect(index_for_pagination(0)).to eq 31
      end
    end
  end
end
