require "rails_helper"

RSpec.describe FlightsController, type: :controller do
  describe "GET #index" do
    context "when user is anonymous" do
      before do
        session[:user_id] = nil
        get :index
      end
      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(login_path) }
    end

    context "when user is logged in" do
      before do
        session[:user_id] = 1
        get :index
      end
      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template("index") }

      describe "#index pagination" do
        context "when there are no flights" do
          it "returns empty array" do
            expect(response.body).to eq ""
            expect(assigns(:flights)).to eq []
          end
        end

        context "when there are flights" do
          before do
            60.times do
              create :flight
            end
          end
          it "returns array of flights" do
            expect(assigns(:flights).empty?).to be_falsey
            expect(assigns(:flights)[0]).to be_instance_of Flight
          end

          context "when page is 1" do
            it "returns flights starting from id 1" do
              flights = assigns(:flights)
              expect(flights.size).to eq 30
              expect(flights[0].id).to eq 1
            end
          end

          context "when page is 2" do
            it "returns flights starting from id 31 " do
              get :index, page: 2
              flights = assigns(:flights)
              expect(flights.size).to eq 30
              expect(flights[0].id).to eq 31
            end
          end
        end
      end
    end
  end

  describe "GET #show" do
    before { create :flight }
    context "when user is anonymous" do
      before { get :show, id: 1 }
      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(login_path) }
    end

    context "when user is logged in" do
      before do
        session[:user_id] = 1
        get :show, id: 1
      end
      it { is_expected.to respond_with 200 }
      it "assigns the requested flight to @flight" do
        expect(assigns(:flight).id).to eq 1
      end
      it { is_expected.to render_template("show") }
    end
  end
end
