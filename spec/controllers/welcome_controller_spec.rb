require "rails_helper"

RSpec.describe WelcomeController, type: :controller do
  describe "#routes" do
    it { should route(:get, "/").to(action: :index) }
    it { should route(:get, "/about").to(action: :about) }
  end

  describe "GET #index" do
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
      3.times do
        create :flight, airline: Faker::Company.name
        create :flight, :jfk_flight, airline: Faker::Company.name
        create :flight, :cancelled, airline: Faker::Company.name
      end
      get :index, enquiry: params[:enquiry]
    end

    it { is_expected.to respond_with 200 }
    it { should render_template("index") }
    it { should set_session[:enquiry] }
    it "returns array of relevant flights" do
      expect(assigns(:enquire).empty?).to be_falsey
      expect(assigns(:enquire)[0]).to be_instance_of Flight
      expect assigns(:enquire).include? create :flight
    end
    it "assigns @passenger_enquiry" do
      expect(assigns(:passenger_enquiry)[:class_selected]).to eq "Business"
    end
  end
end
