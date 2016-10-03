require 'rails_helper'

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
        password: "asdfghj",
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
    end

    context "route and render" do
      before { get :index }
      it { is_expected.to respond_with 200 }
      it { should render_template("index") }
    end
  end
end
