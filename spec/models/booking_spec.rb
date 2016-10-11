require "rails_helper"

RSpec.describe Booking, type: :model do
  describe "#has_many" do
    it { is_expected.to have_many :passengers }
  end

  describe "#has_one" do
    it { is_expected.to have_one :payment }
  end

  describe "#belongs_to" do
    it { is_expected.to belong_to :flight }
  end

  describe "#belongs_to" do
    it { is_expected.to belong_to :user }
  end

  describe "#accepts_nested_attributes_for " do
    it { should accept_nested_attributes_for :passengers }
  end

  describe "validates presence" do
    it { should validate_presence_of(:travel_class) }
  end

  describe ".past_bookings" do
    before do
      create :flight
      3.times { create :booking, :other_user }
      create :booking
    end

    it "returns an array of only the user's past bookings" do
      @bookings = Booking.past_bookings(1)
      expect(Booking.all.count).to eq 4
      expect(@bookings.count).to eq 1
      expect(@bookings.first.user_id).to eq 1
    end
  end
end
