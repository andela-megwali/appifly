require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  before do
    create :flight
    session[:enquiry] = { "number_travelling" => 1 }
  end

  describe "POST #create" do
    context "when any user tries to create a booking" do
      context "create booking success" do
        before do
          post :create,
               select_flight: 1,
               booking: { travel_class: "Business" }
        end

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(booking_path(1)) }
      end

      context "create booking fail" do
        before do
          post :create,
               select_flight: 1,
               booking: { travel_class: "Business",
                          passengers_attributes: [firstname: nil] }
        end

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template("new") }
      end
    end
  end
end
