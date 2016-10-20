require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    before { get :new }

    it { is_expected.to respond_with 200 }
    it { should render_template("new") }
  end

  describe "POST #create" do
    context "create user success" do
      before { post :create, user: attributes_for(:user) }

      it { is_expected.to respond_with 302 }
      it { is_expected.to render_template("notifications/welcome_email") }
      it { should redirect_to(login_path) }
    end

    context "create user fail" do
      before { post :create, user: { firstname: nil } }

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template("new") }
    end
  end
end
