require "rails_helper"

RSpec.describe BookingsController, type: :controller do
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
end
