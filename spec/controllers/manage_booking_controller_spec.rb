require "rails_helper"

RSpec.describe ManageBookingController, type: :controller do
  describe "before action" do
    it { is_expected.to_not use_before_action(:set_booking) }
    it { is_expected.to use_before_action(:verify_user_login) }
  end

  describe "#routes" do
    it { should route(:get, "/past_bookings").to(action: :past) }
    it { should route(:get, "/search_booking").to(action: :search) }
  end

  describe "GET #search" do
    before do
      create :flight
      3.times { create :booking }
    end

    context "when booking reference id is not valid" do
      before { get :search, reference_id: "qwert23467" }

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template("search") }
      it { is_expected.to set_flash[:notice] }
    end

    context "when booking reference id is valid" do
      before { get :search, reference_id: Booking.second.reference_id }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(booking_path(2)) }
      it { is_expected.to set_flash[:notice] }
    end
  end

  describe "GET #past" do
    context "when user is anonymous" do
      before { get :past }

      it { is_expected.to respond_with 302 }
      it { should redirect_to(login_path) }
    end

    context "when user is logged in" do
      before do
        session[:user_id] = 1
        get :past
      end

      it { is_expected.to respond_with 200 }
      it { should render_template("bookings/index") }
    end
  end
end
