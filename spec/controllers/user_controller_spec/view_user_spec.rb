require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "GET #show" do
    before { create :user, firstname: Faker::Name.name }
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
            32.times do
              create :user
            end
          end

          context "when page is 1" do
            it "returns users starting from id 1" do
              users = assigns(:users)
              expect(users[0].id).to eq 1
              expect(users.size).to eq 30
            end
          end

          context "when page is 2" do
            it "returns users starting from id 31 " do
              get :index, page: 2
              users = assigns(:users)
              expect(users[0].id).to eq 31
              expect(users.size).to eq 2
            end
          end
        end
      end
    end
  end
end
