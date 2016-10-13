require "rails_helper"

RSpec.describe FlightsController, type: :controller do
  describe "before action" do
    it { is_expected.to_not use_before_action(:set_airport) }
    it { is_expected.to use_before_action(:set_flight) }
    it { is_expected.to use_before_action(:list_airport) }
    it { is_expected.to use_before_action(:verify_user_login) }
    it { is_expected.to use_before_action(:verify_admin_login) }
  end

  describe "routes" do
    it { should route(:get, "/flights").to(action: :index) }
    it { should route(:get, "/flights/new").to(action: :new) }
    it { should route(:post, "/flights").to(action: :create) }
    it { should route(:get, "/flights/1").to(action: :show, id: 1) }
    it { should route(:get, "/flights/1/edit").to(action: :edit, id: 1) }
    it { should route(:patch, "/flights/1").to(action: :update, id: 1) }
    it { should route(:delete, "/flights/1").to(action: :destroy, id: 1) }
  end

  describe "Params Filter" do
    params = {
      flight: {
        origin: "Lagos (LOS)",
        destination: "New York (JFK)",
        seat: 200,
        arrival: Time.now + 5.days + 50.minutes,
        airline: "Chinese Airways",
        code: "CA122",
        departure: Time.now + 5.days,
        status: "Cancelled",
        admin: true,
        sql: "Yes",
      }
    }
    before do
      session[:admin_user_id] = 1
      create :airport
      create :airport, :jfk_airport
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
