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
      before do
        put :update, id: 1, booking: attributes_for(:booking)
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(login_path) }
    end

    context "when user is logged in" do
      before { session[:user_id] = 1 }

      describe "update booking success" do
        before { put :update, id: 1, booking: attributes_for(:booking) }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(booking_path(1)) }
      end

      describe "update booking fail" do
        before { put :update, id: 1, booking: { travel_class: nil } }

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template("edit") }
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is anonymous" do
      before { delete :destroy, id: 1 }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(login_path) }
    end

    context "when user is logged in" do
      before do
        session[:user_id] = 1
        delete :destroy, id: 1
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(past_bookings_path) }
    end
  end
end
