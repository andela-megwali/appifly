require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe "#routes" do
    it { should route(:get, "/login").to(action: :login) }
    it { should route(:get, "/logout").to(action: :logout) }
    it { should route(:post, "/attempt_login").to(action: :attempt_login) }
  end

  describe "GET #login" do
    before { get :login }

    it { should render_template("login") }
  end

  describe "GET #logout" do
    before do
      session[:admin_user_id] = 1
      session[:user_id] = 1
      session[:user_username] = "Lugard"
      get :logout
    end

    it { is_expected.to respond_with 302 }
    it { should redirect_to(login_path) }
    it "ends the session" do
      expect(session[:user_id]).to equal(nil)
      expect(session[:admin_user_id]).to equal(nil)
      expect(session[:user_username]).to equal(nil)
    end
  end

  describe "POST #attempt_login" do
    before { create :user, firstname: Faker::Name.name }

    context "login with correct details" do
      before do
        params = { username: "John", password: "asdfghj" }
        post :attempt_login, sign_in: params
      end

      it { should_not set_session[:admin_user_id] }
      it { should set_session[:user_id] }
      it { should set_session[:user_username] }
      it "sets the correct session username" do
        expect(session[:user_username]).to eq("John")
      end
      it { is_expected.to respond_with 302 }
      it { should redirect_to(past_bookings_path) }
    end

    context "login with incorrect details" do
      before do
        params = { username: "John", password: "1234567" }
        post :attempt_login, sign_in: params
      end

      it { should_not set_session[:user_id] }
      it { should_not set_session[:user_username] }
      it { should_not set_session[:admin_user_id] }
      it { is_expected.to respond_with 302 }
      it { should redirect_to(login_path) }
    end
  end
end
