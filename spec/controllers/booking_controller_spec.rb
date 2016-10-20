require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  before do
    create :flight
    create :booking
    session[:enquiry] = { "number_travelling" => 1 }
  end

  describe "before action" do
    it { is_expected.to_not use_before_action(:set_flight) }
    it { is_expected.to use_before_action(:set_booking) }
    it { is_expected.to use_before_action(:set_flight_select) }
    it { is_expected.to use_before_action(:verify_user_login) }
  end

  describe "routes" do
    it { should route(:get, "/bookings").to(action: :index) }
    it { should route(:get, "/bookings/new").to(action: :new) }
    it { should route(:post, "/bookings").to(action: :create) }
    it { should route(:get, "/bookings/1").to(action: :show, id: 1) }
    it { should route(:get, "/bookings/1/edit").to(action: :edit, id: 1) }
    it { should route(:patch, "/bookings/1").to(action: :update, id: 1) }
    it { should route(:delete, "/bookings/1").to(action: :destroy, id: 1) }
    it { should route(:get, "/past_bookings").to(action: :past) }
    it { should route(:get, "/search_booking").to(action: :search) }
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
        it { is_expected.to redirect_to(booking_path(2)) }
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
      end
    end
  end

  describe "GET #show" do
    before { get :show, id: 1 }

    it { is_expected.to respond_with 200 }
    it { is_expected.to render_template("show") }
    it "assigns the selected flight" do
      expect(assigns(:flight_selected)).to eq(Flight.first)
    end
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
        before { put :update, id: 1, booking: attributes_for(:booking) }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(booking_path(1)) }
      end

      describe "with an invalid detail in any field" do
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
