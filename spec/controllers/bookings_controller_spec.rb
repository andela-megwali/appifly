require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  describe "before action" do
    it { is_expected.to_not use_before_action(:set_flight) }
    it { is_expected.to use_before_action(:set_booking) }
    it { is_expected.to use_before_action(:set_flight_select) }
    it { is_expected.to use_before_action(:verify_user_login) }
    it { is_expected.to use_before_action(:verify_admin_login) }
  end

  describe "CRUD" do
    params = {
      booking: {
        travel_class: "Economy",
        passengers_attributes: [id: "",
                                nationality: "Nigerian",
                                firstname: "Mary",
                                lastname: "Dan",
                                email: "m@s.com",
                                telephone: "1234567",
                                title: "Mrs",
                                luggage: "No",
                                parents: "two",
                                sql: "no"]
      }
    }
    before do
      create :flight
      create :booking
      session[:enquiry] = { "flight_selected" => 1, "number_travelling" => 1 }
    end

    context "when user is anonymous" do
      describe "can access unrestricted booking CRUD actions/pages" do
        context "#GET new" do
          before { get :new }
          it { is_expected.to respond_with 200 }
          it { is_expected.to render_template("new") }
        end

        context "#POST create success" do
          before { post :create, booking: { travel_class: "Economy" } }
          it { is_expected.to respond_with 302 }
          it { is_expected.to redirect_to(booking_path(2)) }
        end

        context "#POST create fail" do
          before do
            post :create,
                 booking: { travel_class: "Economy",
                            passengers_attributes: [firstname: nil] }
          end
          it { is_expected.to respond_with 200 }
          it { is_expected.to render_template("new") }
        end
      end

      describe "cannot access restricted booking CRUD actions/pages" do
        context "GET #edit" do
          before { get :edit, id: 1 }
          it { is_expected.to respond_with 302 }
          it { is_expected.to redirect_to(login_path) }
        end
      end
    end

    context "when user is logged in" do
      before { session[:user_id] = 1 }
      describe "can access authorised CRUD actions/pages" do
        context "GET #edit" do
          before { get :edit, id: 1 }
          it { is_expected.to respond_with 200 }
          it { is_expected.to render_template("edit") }
        end

        context "GET #show" do
          before { get :show, id: 1 }
          it { is_expected.to respond_with 200 }
          it { is_expected.to render_template("show") }
        end

        context "PUT #update success" do
          before { put :update, id: 1, booking: params }
          it { is_expected.to respond_with 302 }
          it { is_expected.to redirect_to(booking_path) }
        end

        context "PUT #update fail" do
          before do
            put :update,
                id: 1,
                booking: attributes_for(:booking, travel_class: nil)
          end
          it { is_expected.to render_template("edit") }
        end

        context "DELETE #destroy" do
          before { delete :destroy, id: 1 }
          it { is_expected.to respond_with 302 }
          it { is_expected.to redirect_to(past_bookings_path) }
        end
      end

      describe "cannot access admin restricted pages" do
        before { get :index }
        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to("/") }
      end

      context "when logged in as admin" do
        before do
          session[:admin_user_id] = 1
          get :index
        end
        it "can access all restricted pages" do
          is_expected.to respond_with 200
          is_expected.to render_template("index")
        end
      end
    end

    context "Params Filter" do
      it "Should not allow unpermitted params" do
        should_not permit(:parents,
                          :sql).for(:create, params: params).on(:booking)
      end

      it "Should allow the permitted params" do
        should permit(:travel_class,
                      passengers_attributes: [:id,
                                              :nationality,
                                              :firstname,
                                              :email,
                                              :title,
                                              :telephone,
                                              :lastname,
                                              :luggage,
                                              :_destroy]).
          for(:create, params: params).on(:booking)
      end
    end
  end
end
