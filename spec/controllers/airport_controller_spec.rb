require "rails_helper"

RSpec.describe AirportsController, type: :controller do
  before { session[:user_id] = 1 }

  describe "before action" do
    it { should use_before_action(:set_airport) }
    it { should_not use_before_action(:set_flight) }
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
      2.times do
        create :airport, name: Faker::Name.name
      end
    end

    context "routes" do
      it { should route(:get, "/airports").to(action: :index) }
      it { should route(:get, "/airports/new").to(action: :new) }
      it { should route(:post, "/airports").to(action: :create) }
      it { should route(:get, "/airports/1").to(action: :show, id: 1) }
      it { should route(:get, "/airports/1/edit").to(action: :edit, id: 1) }
      it { should route(:patch, "/airports/1").to(action: :update, id: 1) }
      it { should route(:delete, "/airports/1").to(action: :destroy, id: 1) }
    end

    context "GET #show" do
      it "assigns the requested airport to @airport" do
        get :show, id: 1
        expect(assigns(:airport).id).to eq 1
        get :show, id: 2
        expect(assigns(:airport).id).to eq 2
      end
      it "renders the #show view" do
        get :show, id: 1
        expect(response).to render_template :show
      end
    end

    context "GET #edit" do
      it "assigns the requested airport to @airport" do
        get :edit, id: 1
        expect(assigns(:airport).id).to eq 1
        get :edit, id: 2
        expect(assigns(:airport).id).to eq 2
      end
      it "renders the #edit view" do
        get :edit, id: 1
        expect(response).to render_template :edit
      end
    end
  end

  describe "GET #index" do
    before { get :index }
    it { should render_template("index") }

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

      describe "#pagination" do
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

    context "PATCH #update" do
      before do
        create :airport, name: Faker::Name.name
        patch :update, id: 1, airport: params
      end
      it { is_expected.to respond_with 302 }
      it { should redirect_to(airport_path) }
    end

    context "GET #new" do
      before { get :new, airport: params }
      it { is_expected.to respond_with 200 }
      it { should render_template("new") }
    end

    context "POST #create" do
      before { post :create, airport: params }
      it { is_expected.to respond_with 200 }
      it { should render_template("new") }
    end

    context "DELETE #destroy" do
      before do
        create :airport, name: Faker::Name.name
        delete :destroy, id: 1
      end
      it { is_expected.to respond_with 302 }
      it { should redirect_to(airports_path) }
    end
  end
end
