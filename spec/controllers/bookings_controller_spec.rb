require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  describe "before action" do
    it { is_expected.to_not use_before_action(:set_flight) }
    it { is_expected.to use_before_action(:set_booking) }
    it { is_expected.to use_before_action(:set_flight_select) }
    it { is_expected.to use_before_action(:verify_user_login) }
    it { is_expected.to use_before_action(:verify_admin_login) }
  end

  describe "#authenticate" do
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
      create :airport
      Airport.create(name: "Nnamdi Azikiwe Airport",
                     continent: "Africa",
                     country: "Kenya",
                     state_and_code: "Abuja (ABV)",
                     jurisdiction: "International",
                     rating: 10)
      2.times do
        create :flight, airline: Faker::Company.name
      end
      session[:enquiry] = { "flight_selected" => 1, "number_travelling" => 1 }
    end
    context "anonymous user" do
      describe "can access unrestricted booking pages" do
        context "#GET new" do
          before { get :new }
          it { is_expected.to respond_with 200 }
          it { is_expected.to render_template("new") }
        end
      end
    end

    context "logged in user" do
      describe "can access authorised pages" do
        before { session[:user_id] = 1 }
        context "CRUD" do
          before { create :booking }
          describe "GET #edit" do
            before { get :edit, id: 1 }
            it { is_expected.to respond_with 200 }
            it { is_expected.to render_template("edit") }
          end

          describe "GET #show" do
            before { get :show, id: 1 }
            it { is_expected.to respond_with 200 }
            it { is_expected.to render_template("show") }
          end

          describe "PUT #update" do
            context "#update success" do
              before { put :update, id: 1, booking: params }
              it { is_expected.to respond_with 302 }
              it { is_expected.to redirect_to(booking_path) }
            end

            context "#update fail" do
              before do
                put :update,
                    id: 1,
                    booking: attributes_for(:booking, travel_class: nil)
              end
              it { is_expected.to render_template("edit") }
            end
          end

          describe "DELETE #destroy" do
            before { delete :destroy, id: 1 }
            it { is_expected.to respond_with 302 }
            it { is_expected.to redirect_to(past_bookings_path) }
          end
        end
      end

      describe "cannot access restricted pages" do
        before do
          session[:user_id] = 1
          get :index
        end
        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to("/") }
      end

      context "logged in admin can access restricted pages" do
        before do
          session[:admin_user_id] = 1
          get :index
        end
        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template("index") }
      end
    end

    describe "Params Filter" do
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
