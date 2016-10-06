require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  describe "before action" do
    it { should_not use_before_action(:set_flight) }
    it { should use_before_action(:set_booking) }
    it { should use_before_action(:set_flight_select) }
    it { should use_before_action(:verify_user_login) }
    it { should use_before_action(:verify_admin_login) }
  end

  describe "#routes" do
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

  describe "#authenticate" do
    params = {
      booking: {
        travel_class: "Economy",
        passengers_attributes: [id: "",
                                nationality: "Nigerian",
                                firstname: "Mary",
                                lastname: "Dan",
                                email: "m@s.com",
                                telephone: "1234567",
                                title: "Mrs",
                                luggage: "No",
                                _destroy: 0,
                                parents: "two",
                                sql: "no"]
      }
    }
    before do
      create :airport
      Airport.create(name: "Nnamdi Azikiwe Airport",
                     continent: "Africa",
                     country: "Kenya",
                     state_and_code: "Abuja (ABV)",
                     jurisdiction: "International",
                     rating: 10)
      2.times do
        create :flight, airline: Faker::Company.name
      end
      session[:enquiry] = { "flight_selected" => 1, "number_travelling" => 1 }
    end
    context "anonymous user" do
      describe "can access unrestricted booking pages" do
        context "#GET new" do
          before { get :new }
          it { is_expected.to respond_with 200 }
          it { is_expected.to render_template("new") }
        end

        context "#GET search" do
          before { get :search }
          it { is_expected.to respond_with 200 }
          it { is_expected.to render_template("search") }
        end
      end

      describe "cannot access unauthorised pages" do
        before { get :past }
        it { is_expected.to respond_with 302 }
        it { should redirect_to(login_path) }
      end
    end

    context "logged in user" do
      describe "can access authorised pages" do
        before do
          session[:user_id] = 1
          get :past
        end
        it { is_expected.to respond_with 200 }
        it { should render_template("index") }
      end

      describe "cannot access restricted pages" do
        before do
          session[:user_id] = 1
          get :index
        end
        it { is_expected.to respond_with 302 }
        it { should redirect_to("/") }
      end

      context "logged in admin can access restricted pages" do
        before do
          session[:admin_user_id] = 1
          get :index
        end
        it { is_expected.to respond_with 200 }
        it { should render_template("index") }
      end
    end

    describe "Params Filter" do
      it "Should not allow unpermitted params" do
        should_not permit(:parents,
                          :sql).for(:create, params: params).on(:booking)
      end
    end
  end
end
