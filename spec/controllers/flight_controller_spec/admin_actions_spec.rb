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
      before { post :create, flight: FactoryGirl.attributes_for(:flight) }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in user is not admin" do
      before do
        session[:user_id] = 1
        post :create, flight: FactoryGirl.attributes_for(:flight)
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in as admin" do
      before { session[:admin_user_id] = 1 }

      describe "create flight success" do
        before { post :create, flight: FactoryGirl.attributes_for(:flight) }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(flight_path(1)) }
      end

      describe "create flight fail" do
        before { post :create, flight: { name: nil } }

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template("new") }
      end
    end
  end

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

      describe "update flight success" do
        before { put :update, id: 1, flight: { seat: 150 } }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(flight_path(1)) }
      end
      describe "update flight fail" do
        before { put :update, id: 1, flight: { seat: nil } }

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template("edit") }
      end
    end
  end

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
