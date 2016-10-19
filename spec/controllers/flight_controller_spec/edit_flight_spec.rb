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

end
