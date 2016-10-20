require "rails_helper"

RSpec.describe UsersController, type: :controller do
  before { create :user, firstname: Faker::Name.name }

  describe "PUT #update" do
    context "when user is anonymous" do
      before do
        put :update, id: 1, user: attributes_for(:user)
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(login_path) }
    end

    context "when user is logged in" do
      before { session[:user_id] = 1 }

      describe "update user success" do
        before { put :update, id: 1, user: attributes_for(:user) }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(user_path(1)) }
      end

      describe "update user fail" do
        before { put :update, id: 1, user: { firstname: nil } }

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template("edit") }
      end
    end
  end
end
