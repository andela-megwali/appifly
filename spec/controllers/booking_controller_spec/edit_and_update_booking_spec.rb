require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  before do
    create :flight
    create :booking
  end

  describe "GET #edit" do
    context "when user is anonymous" do
      before { get :edit, id: 1 }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(login_path) }
    end

    context "when user is logged in" do
      before do
        session[:user_id] = 1
        get :edit, id: 1
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template("edit") }
    end
  end

  describe "PUT #update" do
    context "when user is anonymous" do
      before { put :update, id: 1, booking: attributes_for(:booking) }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(login_path) }
    end

    context "when user is logged in" do
      before { session[:user_id] = 1 }

      describe "with valid details in every field" do
        before { put :update, id: 1, booking: { travel_class: "First" } }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(booking_path(1)) }
        it "updates the booking attribute" do
          expect(Booking.first.travel_class).to eq "First"
        end
      end

      describe "with an invalid detail in any field" do
        before { put :update, id: 1, booking: { travel_class: nil } }

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template("edit") }
        it "does not update the booking attribute" do
          expect(Booking.first.travel_class).to eq "Economy"
        end
      end
    end
  end
end
