require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  before do
    create :flight
    session[:enquiry] = { "number_travelling" => 1 }
  end

  describe "GET #show" do
    before do
      create :booking
      get :show, id: 1
    end

    it { is_expected.to respond_with 200 }
    it { is_expected.to render_template("show") }
    it "assigns the selected flight" do
      expect(assigns(:flight_selected)).to eq(Flight.first)
    end
  end
end
