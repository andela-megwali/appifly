require "rails_helper"

RSpec.describe AirportsController, type: :controller do
  describe "POST #create" do
    context "when user is anonymous" do
      before { post :create, airport: FactoryGirl.attributes_for(:airport) }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in user is not admin" do
      before do
        session[:user_id] = 1
        post :create, airport: FactoryGirl.attributes_for(:airport)
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in as admin" do
      before { session[:admin_user_id] = 1 }

      describe "create airport success" do
        before { post :create, airport: FactoryGirl.attributes_for(:airport) }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(airport_path(1)) }
      end

      describe "create airport fail" do
        before { post :create, airport: { name: nil } }

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template("new") }
      end
    end
  end
end
