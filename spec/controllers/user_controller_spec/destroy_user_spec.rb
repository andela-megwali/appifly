require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "DELETE #destroy" do
    before { create :user, firstname: Faker::Name.name }

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
      it { should redirect_to(users_path) }
      it "destroys the user" do
        expect(User.count).to eq 0
      end
    end
  end
end
