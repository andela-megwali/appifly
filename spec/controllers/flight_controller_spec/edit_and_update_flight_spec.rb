require "rails_helper"

RSpec.describe FlightsController, type: :controller do
  describe "GET #edit" do
    before { create :flight }

    context "when user is anonymous" do
      before { get :edit, id: 1 }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in user is not admin" do
      before do
        session[:user_id] = 1
        get :edit, id: 1
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in as admin" do
      before do
        session[:admin_user_id] = 1
        get :edit, id: 1
      end

      it { is_expected.to respond_with 200 }
      it "assigns the requested flight to @flight" do
        expect(assigns(:flight).id).to eq 1
      end
      it { is_expected.to render_template("edit") }
    end
  end

  describe "PUT #update" do
    before { create :flight }

    context "when user is anonymous" do
      before do
        put :update, id: 1, flight: { seat: 150 }
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in user is not admin" do
      before do
        session[:user_id] = 1
        put :update, id: 1, flight: { seat: 150 }
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in as admin" do
      before { session[:admin_user_id] = 1 }

      describe "with valid flight attributes" do
        before { put :update, id: 1, flight: { seat: 150 } }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(flight_path(1)) }
        it "updates the flight attribute" do
          expect(Flight.first.seat).to eq 150
        end
      end
      describe "with an invalid flight attribute" do
        before { put :update, id: 1, flight: { seat: nil } }

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template("edit") }
        it "does not update the flight attribute" do
          expect(Flight.first.seat).to eq 200
        end
      end
    end
  end
end
