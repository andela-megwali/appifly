require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    before { get :new }

    it { is_expected.to respond_with 200 }
    it { should render_template("new") }
  end

  describe "POST #create" do
    context "with valid user attributes" do
      before { post :create, user: attributes_for(:user) }

      it { is_expected.to respond_with 302 }
      it { is_expected.to render_template("notifications/welcome_email") }
      it { should redirect_to(login_path) }
      it "creates a new user" do
        expect(User.count).to eq 1
      end
    end

    context "with an invalid user attribute" do
      before { post :create, user: { firstname: nil } }

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template("new") }
      it "does not create a new user" do
        expect(User.count).to eq 0
      end
    end
  end
end
