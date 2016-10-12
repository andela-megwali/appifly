require "rails_helper"

RSpec.describe AirportsController, type: :controller do
  before { session[:admin_user_id] = 1 }
  describe "before action" do
    it { is_expected.to use_before_action(:set_airport) }
    it { is_expected.to_not use_before_action(:set_flight) }
    it { is_expected.to_not use_before_action(:verify_user_login) }
    it { is_expected.to use_before_action(:verify_admin_login) }
  end

  describe "routes" do
    it { should route(:get, "/airports").to(action: :index) }
    it { should route(:get, "/airports/new").to(action: :new) }
    it { should route(:post, "/airports").to(action: :create) }
    it { should route(:get, "/airports/1").to(action: :show, id: 1) }
    it { should route(:get, "/airports/1/edit").to(action: :edit, id: 1) }
    it { should route(:patch, "/airports/1").to(action: :update, id: 1) }
    it { should route(:delete, "/airports/1").to(action: :destroy, id: 1) }
  end
    
  describe "Params Filter" do
    params = {
      airport: {
        name: "Murtala Muhammad",
        continent: "Africa",
        country: "Nigeria",
        jurisdiction: "International",
        state_and_code: "Lagos (LOS)",
        rating: 10,
        admin: true,
        sql: "Yes",
      }
    }
    before { create :airport }
    it "Should allow the permitted params" do
      should permit(:name,
                    :continent,
                    :country,
                    :jurisdiction,
                    :state_and_code,
                    :rating).for(:create, params: params).on(:airport)
    end

    it "Should not allow unpermitted params" do
      should_not permit(:admin, :sql).for(:create, params: params).on(:airport)
    end
  end
end
