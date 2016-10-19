require "rails_helper"

RSpec.describe UsersController, type: :controller do
  before { create :user, firstname: Faker::Name.name }

  describe "GET #show" do
    context "when user is anonymous" do
      before { get :show, id: 1 }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(login_path) }
    end

    context "when user is logged in" do
      before do
        session[:user_id] = 1
        get :show, id: 1
      end

      it { is_expected.to respond_with 200 }
      it "assigns the requested user to @user" do
        expect(assigns(:user).id).to eq 1
      end
      it { is_expected.to render_template("show") }
    end
  end
end
