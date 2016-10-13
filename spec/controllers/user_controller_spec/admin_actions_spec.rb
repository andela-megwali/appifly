require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    context "when user is anonymous" do
      before { get :index }
      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in user is not admin" do
      before do
        session[:user_id] = 1
        get :index
      end
      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(root_path) }
    end

    context "when logged in as admin" do
      before do
        session[:admin_user_id] = 1
        get :index
      end
      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template("index") }

      describe "#index pagination" do
        context "when there are no users" do
          it "returns empty array" do
            expect(response.body).to eq ""
            expect(assigns(:users)).to eq []
          end
        end

        context "when there are users" do
          before do
            60.times do
              create :user
            end
          end
          it "returns array of users" do
            expect(assigns(:users).empty?).to be_falsey
            expect(assigns(:users)[0]).to be_instance_of User
          end

          context "when page is 1" do
            it "returns users starting from id 1" do
              users = assigns(:users)
              expect(users.size).to eq 30
              expect(users[0].id).to eq 1
            end
          end

          context "when page is 2" do
            it "returns users starting from id 31 " do
              get :index, page: 2
              users = assigns(:users)
              expect(users.size).to eq 30
              expect(users[0].id).to eq 31
            end
          end
        end
      end
    end
  end

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
    end
  end
end
