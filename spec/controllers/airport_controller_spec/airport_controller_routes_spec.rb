require "rails_helper"

RSpec.describe AirportsController, type: :controller do
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
end
