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
      # binding.pry
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
  end
end
