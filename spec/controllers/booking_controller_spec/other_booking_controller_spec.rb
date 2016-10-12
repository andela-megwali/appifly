require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  describe "before action" do
    it { is_expected.to_not use_before_action(:set_flight) }
    it { is_expected.to use_before_action(:set_booking) }
    it { is_expected.to use_before_action(:set_flight_select) }
    it { is_expected.to use_before_action(:verify_user_login) }
    it { is_expected.to use_before_action(:verify_admin_login) }
  end

  describe "routes" do
    it { should route(:get, "/bookings").to(action: :index) }
    it { should route(:get, "/bookings/new").to(action: :new) }
    it { should route(:post, "/bookings").to(action: :create) }
    it { should route(:get, "/bookings/1").to(action: :show, id: 1) }
    it { should route(:get, "/bookings/1/edit").to(action: :edit, id: 1) }
    it { should route(:patch, "/bookings/1").to(action: :update, id: 1) }
    it { should route(:delete, "/bookings/1").to(action: :destroy, id: 1) }
  end

  describe "Params Filter" do
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
                                parents: "two",
                                sql: "no"]
      }
    }
    before do
      create :flight
      session[:enquiry] = { "flight_selected" => 1 }
    end

    it "Should not allow unpermitted params" do
      should_not permit(:parents,
                        :sql).for(:create, params: params).on(:booking)
    end

    it "Should allow the permitted params" do
      should permit(:travel_class,
                    passengers_attributes: [:id,
                                            :nationality,
                                            :firstname,
                                            :email,
                                            :title,
                                            :telephone,
                                            :lastname,
                                            :luggage,
                                            :_destroy]).
        for(:create, params: params).on(:booking)
    end
  end
end
