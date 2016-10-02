require 'rails_helper'

RSpec.describe UsersController, type: :controller do
   describe "before action" do
    it { should use_before_action(:set_user) }
    it { should_not use_before_action(:list_airport) }
    it { should use_before_action(:verify_user_login) }
    it { should use_before_action(:verify_admin_login) }
  end

  describe "#routes and CRUD" do
    context "routes" do
      it { should route(:get, "/users").to(action: :index) }
      it { should route(:get, "/users/new").to(action: :new) }
      it { should route(:post, "/users").to(action: :create) }
      it { should route(:get, "/users/1").to(action: :show, id: 1) }
      it { should route(:get, "/users/1/edit").to(action: :edit, id: 1) }
      it { should route(:patch, "/users/1").to(action: :update, id: 1) }
      it { should route(:delete, "/users/1").to(action: :destroy, id: 1) }
    end
  end

  describe "Params Filter" do
    it "Should allow the permitted params" do
      params = {
                user: {
                        title: "Mrs",
                        firstname: "Moses",
                        lastname: "Joe",
                        username: "MJ",
                        password: "asdfghj",
                        email: "m@j.com",
                        telephone: "1234567890",
                        subscription: true,
                      }
                }
      should permit(:title,
                    :firstname,
                    :lastname,
                    :username,
                    :password,
                    :email,
                    :telephone,
                    :subscription).for(:create, params: params).on(:user)
    end
  end
end
