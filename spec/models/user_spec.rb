require "rails_helper"

RSpec.describe User, type: :model do
  describe "#has_many" do
    it { is_expected.to have_many :bookings }
  end

  describe "#has_many" do
    it { should have_secure_password }
  end
end
