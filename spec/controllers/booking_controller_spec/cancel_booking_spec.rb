require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  before do
    create :flight
    create :booking
  end

  describe "DELETE #destroy" do
    context "when user is anonymous" do
      before { delete :destroy, id: 1 }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(login_path) }
    end

    context "when user is logged in" do
      before do
        session[:user_id] = 1
        delete :destroy, id: 1
      end

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to(past_bookings_path) }
      it { is_expected.to set_flash[:notice] }
      it "destroys the booking" do
        expect(Booking.count).to eq 0
      end
    end
  end
end
