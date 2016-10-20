require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  before do
    create :flight
    session[:enquiry] = { "number_travelling" => 1 }
  end

  describe "GET #new" do
    context "when any user tries to access" do
      context "when no valid flight is selected" do
        before do
          request.env["HTTP_REFERER"] = "http://test.com/sessions/new"
          session[:enquiry] = { "flight_selected" => nil }
          get :new
        end

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(request.env["HTTP_REFERER"]) }
      end

      context "when a valid flight is selected" do
        before { get :new, select_flight: 1 }

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template("new") }
      end
    end
  end

  describe "POST #create" do
    context "when any user tries to create a booking" do
      context "with valid details in every field" do
        before do
          post :create,
               select_flight: 1,
               booking: { travel_class: "Business" }
        end

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(booking_path(1)) }
        it "creates a new booking" do
          expect(Booking.count).to eq 1
        end
      end

      context "with an invalid detail in any field" do
        before do
          post :create,
               select_flight: 1,
               booking: { travel_class: "Business",
                          passengers_attributes: [firstname: nil] }
        end

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template("new") }
        it "does not creates a new booking" do
          expect(Booking.count).to eq 0
        end
      end
    end
  end
end
