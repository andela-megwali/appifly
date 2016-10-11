require "rails_helper"

RSpec.describe AirportsController, type: :controller do
  before { session[:admin_user_id] = 1 }
  describe "before action" do
    it { is_expected.to use_before_action(:set_airport) }
    it { is_expected.to_not use_before_action(:set_flight) }
    it { is_expected.to_not use_before_action(:verify_user_login) }
    it { is_expected.to use_before_action(:verify_admin_login) }
  end

  describe "GET #index" do
    context "when actions are attempted without admin access" do
      before { session[:admin_user_id] = nil }
      context "when logged in user is not admin" do
        before do
          session[:user_id] = 1
          get :index
        end
        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(root_path) }
      end

      context "when logged out" do
        before { get :index }
        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(root_path) }
      end
    end

    context "when logged in as admin" do
      before { get :index }
      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template("index") }
    end
  end

  describe "#index pagination" do
    before { get :index }
    context "when there are no airports" do
      it "returns empty array" do
        expect(response.body).to eq ""
        expect(assigns(:airports)).to eq []
      end
    end

    context "when there are airports" do
      before do
        60.times do
          create :airport, name: Faker::Name.name
        end
      end

      it "returns array of airports" do
        expect(assigns(:airports).empty?).to be_falsey
        expect(assigns(:airports)[0]).to be_instance_of Airport
      end

      context "when page is 1" do
        it "returns airports starting from id 1" do
          airports = assigns(:airports)
          expect(airports.size).to eq 30
          expect(airports[0].id).to eq 1
        end
      end

      context "when page is 2" do
        it "returns airports starting from id 31 " do
          get :index, page: 2
          airports = assigns(:airports)
          expect(airports.size).to eq 30
          expect(airports[0].id).to eq 31
        end
      end
    end
  end

  describe "CRUD actions" do
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
    before do
      2.times do
        create :airport, name: Faker::Name.name
      end
    end

    context "GET #new" do
      before { get :new }
      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template("new") }
    end

    context "POST #create" do
      before { post :create, airport: params }
      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template("new") }
    end

    context "GET #show" do
      before { get :show, id: 1 }
      it "assigns the requested airport to @airport" do
        expect(assigns(:airport).id).to eq 1
      end
      it { is_expected.to render_template("show") }
    end

    context "GET #edit" do
      it "renders the #edit view" do
        get :edit, id: 1
        expect(response).to render_template :edit
      end
    end

    context "PATCH #update success" do
      before do
        patch :update, id: 1, airport: attributes_for(:airport, country: "Chad")
      end
      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(airport_path) }
    end

    context "PATCH #update fail" do
      before do
        patch :update, id: 1, airport: attributes_for(:airport, country: nil)
      end
      it { is_expected.to respond_with 200 }
      it "re-renders the edit method" do
        expect(response).to render_template :edit
      end
    end

    context "DELETE #destroy" do
      before { delete :destroy, id: 1 }
      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(airports_path) }
    end

    describe "Params Filter" do
      it "Should allow the permitted params" do
        should permit(:name,
                      :continent,
                      :country,
                      :jurisdiction,
                      :state_and_code,
                      :rating).for(:create, params: params).on(:airport)
      end

      it "Should not allow unpermitted params" do
        should_not permit(:admin, :sql).
          for(:create, params: params).on(:airport)
      end
    end
  end
end
