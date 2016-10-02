require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "before action" do
    it { should use_before_action(:set_user) }
    it { should_not use_before_action(:list_airport) }
    it { should use_before_action(:verify_user_login) }
    it { should use_before_action(:verify_admin_login) }
  end

  describe "#routes" do
    it { should route(:get, "/users").to(action: :index) }
    it { should route(:get, "/users/new").to(action: :new) }
    it { should route(:post, "/users").to(action: :create) }
    it { should route(:get, "/users/1").to(action: :show, id: 1) }
    it { should route(:get, "/users/1/edit").to(action: :edit, id: 1) }
    it { should route(:patch, "/users/1").to(action: :update, id: 1) }
    it { should route(:delete, "/users/1").to(action: :destroy, id: 1) }
  end

  describe "Params Filter" do
    params = {
              user: {
                      title: "Mrs",
                      firstname: "Moses",
                      lastname: "Joanne",
                      username: "MJ",
                      password: "asdfghj",
                      email: "m@j.com",
                      telephone: "1234567890",
                      subscription: true,
                      admin: true,
                      sql: "Yes",
                    }
              }
    it "Should allow the permitted params" do
      should permit(:title,
                    :firstname,
                    :lastname,
                    :username,
                    :password,
                    :email,
                    :telephone,
                    :subscription).for(:create, params: params).on(:user)
    end

    it "Should not allow unpermitted params" do
      should_not permit(:admin, :sql).for(:create, params: params).on(:user)
    end
  end

  describe "#authenticate" do
    before do
      session[:user_id] = 1
      create :user, firstname: Faker::Name.name
    end

    context "when logged in" do
      before { get :show, id: 1 }
      it { is_expected.to respond_with 200 }
    end

    context "when user requests restricted action" do
      before { get :index }
      it { is_expected.to respond_with 302 }
      it { should redirect_to(login_path) }
    end

    context "when admin requests restricted action" do
      before do
        session[:admin_user_id] = 1
        get :index
      end
      it { is_expected.to respond_with 200 }
      it { should render_template("index") }
    end

    context "when logged out" do
      before do
        session[:user_id] = nil
        get :show, id: 1
      end
      it { is_expected.to respond_with 302 }
      it { should redirect_to(login_path) }
    end
  end

  describe "#CRUD Actions" do
    params = {
              user: {
                      title: "Mrs",
                      firstname: "Moses",
                      lastname: "Joanne",
                      username: "MJ",
                      password: "asdfghj",
                      email: "m@j.com",
                      telephone: "1234567890",
                      subscription: true,
                    }
              }
    before do
      2.times do
        create :user, firstname: Faker::Name.name
      end
      session[:admin_user_id] = 1
    end

    context "GET #show" do
      it "assigns the requested user to @user" do
        get :show, id: 1
        expect(assigns(:user).id).to eq 1
        get :show, id: 2
        expect(assigns(:user).id).to eq 2
      end
      it "renders the #show view" do
        get :show, id: 1
        expect(response).to render_template :show
      end
    end

    context "GET #edit" do
      it "assigns the requested user to @user" do
        get :edit, id: 1
        expect(assigns(:user).id).to eq 1
        get :edit, id: 2
        expect(assigns(:user).id).to eq 2
      end
      it "renders the #edit view" do
        get :edit, id: 1
        expect(response).to render_template :edit
      end
    end

    context "GET #index" do
      before { get :index }
      it { should render_template("index") }
    end

    context "PATCH #update" do
      before { patch :update, id: 1, user: params }
      it { is_expected.to respond_with 302 }
      it { should redirect_to(user_path) }
    end

    context "GET #new" do
      before { get :new, user: params }
      it { is_expected.to respond_with 200 }
      it { should render_template("new") }
    end

    context "POST #create" do
      before { post :create, user: params }
      it { is_expected.to respond_with 200 }
      it { should render_template("new") }
    end

    context "DELETE #destroy" do
      before do
        delete :destroy, id: 1
      end
      it { is_expected.to respond_with 302 }
      it { should redirect_to(users_path) }
    end
  end
end
