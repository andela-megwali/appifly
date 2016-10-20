require "rails_helper"

RSpec.describe UsersController, type: :controller do
  before { create :user, firstname: Faker::Name.name }

  describe "GET #edit" do
    context "when user is anonymous" do
      before { get :edit, id: 1 }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(login_path) }
    end

    context "when user is logged in" do
      before do
        session[:user_id] = 1
        get :edit, id: 1
      end

      it { is_expected.to respond_with 200 }
      it "assigns the requested user to @user" do
        expect(assigns(:user).id).to eq 1
      end
      it { is_expected.to render_template("edit") }
    end
  end

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

      describe "with valid user attributes" do
        before do
          put :update, id: 1, user: { username: "Mali", password: "1234567" }
        end

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to(user_path(1)) }
        it "updates the user attribute" do
          expect(User.first.username).to eq "Mali"
        end
      end

      describe "with invalid user attribute" do
        before do
          put :update, id: 1, user: { username: nil, password: "1234567" }
        end

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template("edit") }
        it "does not update the user attribute" do
          expect(User.first.username).to eq "John"
        end
      end
    end
  end
end
