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
end
