require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  before do
    create :flight
    create :booking
  end

  describe "GET #show" do
    before { get :show, id: 1 }

    it { is_expected.to respond_with 200 }
    it { is_expected.to render_template("show") }
    it "assigns the selected flight" do
      expect(assigns(:flight_selected)).to eq(Flight.first)
    end
  end

  describe "GET #index" do
    context "when user is anonymous" do
      before { get :index }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(login_path) }
    end

    context "when logged in user is not admin" do
      before do
        session[:user_id] = 1
        get :index
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(past_bookings_path) }
    end

    context "when logged in as admin" do
      before do
        session[:admin_user_id] = 1
        get :index
      end

      it { is_expected.to respond_with :success }
      it { is_expected.to render_template("index") }
      it "assigns list of all bookings to @bookings" do
        expect(response.body).to eq ""
        expect(assigns(:bookings).count).to eq Booking.count
      end
    end
  end

  describe "GET #search" do
    before do
      2.times { create :booking }
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
