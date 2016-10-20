require "rails_helper"

RSpec.describe FlightsController, type: :controller do
  describe "DELETE #destroy" do
    before { create :flight }

    context "when user is anonymous" do
      before { delete :destroy, id: 1 }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in user is not admin" do
      before do
        session[:user_id] = 1
        delete :destroy, id: 1
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in as admin" do
      before do
        session[:admin_user_id] = 1
        delete :destroy, id: 1
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(flights_path) }
    end
  end
end
