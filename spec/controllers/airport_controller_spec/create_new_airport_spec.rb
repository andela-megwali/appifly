require "rails_helper"

RSpec.describe AirportsController, type: :controller do
  describe "GET #new" do
    context "when user is anonymous" do
      before { get :new }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in user is not admin" do
      before do
        session[:user_id] = 1
        get :new
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in as admin" do
      before do
        session[:admin_user_id] = 1
        get :new
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template("new") }
    end
  end

  describe "POST #create" do
    context "when user is anonymous" do
      before { post :create, airport: attributes_for(:airport) }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in user is not admin" do
      before do
        session[:user_id] = 1
        post :create, airport: attributes_for(:airport)
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in as admin" do
      before { session[:admin_user_id] = 1 }

      describe "with valid airport attributes" do
        before { post :create, airport: attributes_for(:airport) }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(airport_path(1)) }
        it "creates a new airport" do
          expect(Airport.count).to eq 1
        end
      end

      describe "with an invalid airport attribute" do
        before { post :create, airport: { name: nil } }

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template("new") }
        it "does not create a new airport" do
          expect(Airport.count).to eq 0
        end
      end
    end
  end
end
