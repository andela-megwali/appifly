require "rails_helper"

RSpec.describe User, type: :model do
  describe "#has_many" do
    it { is_expected.to have_many :bookings }
  end

  describe "#has_many" do
    it { should have_secure_password }
  end

  describe "validates presence" do
    it { should validate_presence_of(:firstname) }
    it { should validate_presence_of(:lastname) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password) }
  end
end
