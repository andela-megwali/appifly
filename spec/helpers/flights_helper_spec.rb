require "rails_helper"

# Specs in this file have access to a helper object that includes
# the ManageBookingHelper. For example:
#
# describe ManageBookingHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
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
end
