require "rails_helper"

RSpec.describe AirportsController, type: :controller do
  describe "GET #index" do
    context "when user is anonymous" do
      before { get :index }
      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in user is not admin" do
      before do
        session[:user_id] = 1
        get :index
      end
      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in as admin" do
      before do
        session[:admin_user_id] = 1
        get :index
      end
      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template("index") }

      describe "#index pagination" do
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
    end
  end  
end
