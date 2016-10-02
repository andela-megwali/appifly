require 'rails_helper'

RSpec.describe FlightsController, type: :controller do
  before { session[:user_id] = 1 }

  describe "before action" do
    it { should_not use_before_action(:set_airport) }
    it { should use_before_action(:set_flight) }
    it { should use_before_action(:list_airport) }
    it { should use_before_action(:verify_user_login) }
  end

  describe "#authenticate" do
    context 'when logged in' do
      before { get :index }
      it { is_expected.to respond_with 200 }
    end
    context 'when logged out' do
      before do
        session[:user_id] = nil
        get :index
      end
      it { is_expected.to respond_with 302 }
      it { should redirect_to(login_path) }
    end
  end

  describe "#routes and CRUD" do
    before do
      create :airport
      Airport.create(name: "Nnamdi Azikiwe Airport",
                     continent: "Africa",
                     country: "Nigeria",
                     state_and_code: "Abuja (ABV)",
                     jurisdiction: "International",
                     rating: 10)
      2.times do
        create :flight, airline: Faker::Company.name
      end
    end

    context "routes" do
      it { should route(:get, "/flights").to(action: :index) }
      it { should route(:get, "/flights/new").to(action: :new) }
      it { should route(:post, "/flights").to(action: :create) }
      it { should route(:get, "/flights/1").to(action: :show, id: 1) }
      it { should route(:get, "/flights/1/edit").to(action: :edit, id: 1) }
      it { should route(:patch, "/flights/1").to(action: :update, id: 1) }
      it { should route(:delete, "/flights/1").to(action: :destroy, id: 1) }
    end

    context "GET #show" do
      it "assigns the requested flight to @flight" do
        get :show, id: 1
        expect(assigns(:flight).id).to eq 1
        get :show, id: 2
        expect(assigns(:flight).id).to eq 2
      end
      it "renders the #show view" do
        get :show, id: 1
        expect(response).to render_template :show
      end
    end

    context "GET #edit" do
      it "assigns the requested flight to @flight" do
        get :edit, id: 1
        expect(assigns(:flight).id).to eq 1
        get :edit, id: 2
        expect(assigns(:flight).id).to eq 2
      end
      it "renders the #edit view" do
        get :edit, id: 1
        expect(response).to render_template :edit
      end
    end

    context "GET #new" do
      before do
        create :airport
        Airport.create(name: "Kenyatta Airport",
                       continent: "Africa",
                       country: "Kenya",
                       state_and_code: "Nairobi (NBO)",
                       jurisdiction: "International",
                       rating: 10)
        params = {
                    flight: {
                              origin: "Lagos (LOS)",
                              destination: "Nairobi (NBO)",
                              seat: 200,
                              cost: 230,
                              arrival: Time.now + 5.days + 50.minutes,
                              airline: "Chinese Airways",
                              code: "CA122",
                              departure: Time.now + 5.days,
                              status: "Yes",
                            }
                  }
        get :new, flight: params
      end
      it { is_expected.to respond_with 200 }
      it { should render_template("new") }
    end

    context "POST #create" do
      before do
        create :airport
        Airport.create(name: "Kenyatta Airport",
                       continent: "Africa",
                       country: "Kenya",
                       state_and_code: "Nairobi (NBO)",
                       jurisdiction: "International",
                       rating: 10)
        params = {
                    flight: {
                              origin: "Lagos (LOS)",
                              destination: "Nairobi (NBO)",
                              seat: 200,
                              cost: 230,
                              arrival: Time.now + 5.days + 50.minutes,
                              airline: "Chinese Airways",
                              code: "CA122",
                              departure: Time.now + 5.days,
                              status: "No",
                            }
                  }
        post :create, flight: params
      end
      it { is_expected.to respond_with 200 }
      it { should render_template("new") }
    end

    context "PATCH #update" do
      before do
        create :airport
        Airport.create(name: "Kenyatta Airport",
                       continent: "Africa",
                       country: "Kenya",
                       state_and_code: "Nairobi (NBO)",
                       jurisdiction: "International",
                       rating: 10)
        params = {
                    flight: {
                              origin: "Lagos (LOS)",
                              destination: "Nairobi (NBO)",
                              seat: 200,
                              cost: 230,
                              arrival: Time.now + 5.days + 50.minutes,
                              airline: "Chinese Airways",
                              code: "CA122",
                              departure: Time.now + 5.days,
                              status: "No",
                            }
                  }
        patch :update, id: 1, flight: params
      end
      it { is_expected.to respond_with 302 }
      it { should redirect_to(flight_path) }
    end

    context "DELETE #destroy" do
      before do
        create :airport, name: Faker::Name.name
        create :flight
        delete :destroy, id: 1
      end
      it { is_expected.to respond_with 302 }
      it { should redirect_to(flights_path) }
    end
  end

  describe "Params Filter" do
    params = {
                flight: {
                          origin: "Lagos (LOS)",
                          destination: "New York (JFK)",
                          seat: 200,
                          cost: 230,
                          arrival: Time.now + 5.days + 50.minutes,
                          airline: "Chinese Airways",
                          code: "CA122",
                          departure: Time.now + 5.days,
                          status: "Yes",
                          admin: true,
                          sql: "Yes",
                        }
              }
    before do
      create :airport
      Airport.create(name: "Jefferson Airport",
                     continent: "North America",
                     country: "United States",
                     state_and_code: "New York (JFK)",
                     jurisdiction: "International",
                     rating: 10)
    end
    it "Should allow the permitted params" do  
      should permit(:origin,
                    :destination,
                    :seat,
                    :cost,
                    :arrival,
                    :airline,
                    :code,
                    :departure,
                    :status).for(:create, params: params).on(:flight)
    end

    it "Should not allow unpermitted params" do
      should_not permit(:admin, :sql).for(:create, params: params).on(:flight)
    end
  end
end
