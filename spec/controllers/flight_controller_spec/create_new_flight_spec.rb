require "rails_helper"

RSpec.describe FlightsController, type: :controller do
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
      before { post :create, flight: attributes_for(:flight) }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in user is not admin" do
      before do
        session[:user_id] = 1
        post :create, flight: attributes_for(:flight)
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in as admin" do
      before { session[:admin_user_id] = 1 }

      describe "with valid flight attributes" do
        before { post :create, flight: attributes_for(:flight) }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(flight_path(1)) }
      end

      describe "with an invalid flight attribute" do
        before { post :create, flight: { name: nil } }

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template("new") }
      end
    end
  end
end
