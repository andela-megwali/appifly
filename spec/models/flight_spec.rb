require "rails_helper"

RSpec.describe Flight, type: :model do
  describe "#has_many" do
    it { is_expected.to have_many :bookings }
  end

  describe "#belongs_to" do
    it { is_expected.to belong_to :airport }
  end

  describe "validates presence" do
    it { should validate_presence_of(:seat) }
    it { should validate_presence_of(:departure) }
    it { should validate_presence_of(:arrival) }
    it { should validate_presence_of(:airline) }
    it { should validate_presence_of(:code) }
  end

  describe ".search" do
    before do
      3.times do
        create :flight
        create :flight, :nairobi_flight
        create :flight, :jfk_flight
        create :flight, :cancelled
      end
    end

    it "responds to search" do
      expect(Flight).to respond_to(:search)
    end

    it "returns flights that meet search criteria" do
      @flights = Flight.search("Lagos (LOS)",
                               "Abuja (ABV)",
                               Time.now,
                               Time.now,
                               "Booking")
      expect(@flights.count).to eq 3
      expect(@flights.first.destination).to eq (create :flight).destination
      expect(@flights.first).to_not eq (create :flight, :cancelled).status
    end
  end
end
