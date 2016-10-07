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
    it { should validate_presence_of(:cost) }
  end

  describe "#search" do
    it "responds to search" do
      expect(Flight).to respond_to(:search)
    end
  end
end
