require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  describe "GET #index" do
    before do
      create :flight
    end
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
        context "when there are no bookings" do
          it "returns empty array" do
            expect(response.body).to eq ""
            expect(assigns(:bookings)).to eq []
          end
        end

        context "when there are bookings" do
          before do
            60.times do
              create :booking
            end
          end
          it "returns array of bookings" do
            expect(assigns(:bookings).empty?).to be_falsey
            expect(assigns(:bookings)[0]).to be_instance_of Booking
          end

          context "when page is 1" do
            it "returns bookings starting from id 1" do
              bookings = assigns(:bookings)
              expect(bookings.size).to eq 30
              expect(bookings[0].id).to eq 1
            end
          end

          context "when page is 2" do
            it "returns bookings starting from id 31 " do
              get :index, page: 2
              bookings = assigns(:bookings)
              expect(bookings.size).to eq 30
              expect(bookings[0].id).to eq 31
            end
          end
        end
      end
    end
  end
end
