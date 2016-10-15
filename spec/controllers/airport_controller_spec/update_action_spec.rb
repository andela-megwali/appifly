require "rails_helper"

RSpec.describe AirportsController, type: :controller do
  describe "PUT #update" do
    before { create :airport }

    context "when user is anonymous" do
      before do
        put :update, id: 1, airport: { country: "Niger" }
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in user is not admin" do
      before do
        session[:user_id] = 1
        put :update, id: 1, airport: { country: "Niger" }
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in as admin" do
      before { session[:admin_user_id] = 1 }

      describe "update airport success" do
        before { put :update, id: 1, airport: { country: "Niger" } }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(airport_path(1)) }
      end

      describe "update airport fail" do
        before { put :update, id: 1, airport: { country: nil } }

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template("edit") }
      end
    end
  end
end
