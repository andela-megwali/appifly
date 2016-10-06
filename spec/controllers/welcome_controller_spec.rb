require "rails_helper"

RSpec.describe WelcomeController, type: :controller do
  describe "#routes" do
    it { should route(:get, "/").to(action: :index) }
    it { should route(:get, "/about").to(action: :about) }
  end
  describe "#index" do
    params = {
      enquiry: {
        origin: "Lagos (LOS)",
        destination: "Abuja (ABV)",
        departure: Time.now,
        view_format: "Grid",
        travel_class: "Business",
        passenger: "2",
        subscription: true,
        admin: true,
        sql: "Yes",
      }
    }
    before do
      session[:admin_user_id] = 1
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
      get :index, enquiry: params
    end

    context "route and render" do
      it { is_expected.to respond_with 200 }
      it { should render_template("index") }
    end

    context "#search flights" do
      it { should set_session[:enquiry] }
    end

    context "params filter" do
      it "Should allow the permitted params" do
        should permit(:origin,
                      :destination,
                      :departure,
                      :travel_class,
                      :passenger,
                      :view_format).
          for(:index, verb: :get, params: params).on(:enquiry)
      end

      it "Should not allow unpermitted params" do
        should_not permit(:admin, :sql, :subscription).
          for(:index, verb: :get, params: params).on(:enquiry)
      end
    end
  end
end
