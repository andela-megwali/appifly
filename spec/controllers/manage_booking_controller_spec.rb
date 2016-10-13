require "rails_helper"

RSpec.describe ManageBookingController, type: :controller do
  describe "before action" do
    it { is_expected.to_not use_before_action(:set_booking) }
    it { is_expected.to use_before_action(:verify_user_login) }
  end

  describe "#routes" do
    it { should route(:get, "/past_bookings").to(action: :past) }
    it { should route(:get, "/search_booking").to(action: :search) }
  end

  describe "#authenticate" do
    context "anonymous user" do
      describe "can access unrestricted booking pages" do
        context "#GET search" do
          before { get :search }
          it { is_expected.to respond_with 200 }
          it { is_expected.to render_template("search") }
        end
      end

      describe "cannot access unauthorised pages" do
        before { get :past }
        it { is_expected.to respond_with 302 }
        it { should redirect_to(login_path) }
      end
    end

    context "logged in user" do
      describe "can access authorised pages" do
        before { session[:user_id] = 1 }
        describe "GET #past" do
          before { get :past }
          it { is_expected.to respond_with 200 }
          it { should render_template("bookings/index") }
        end
      end
    end
  end
end
