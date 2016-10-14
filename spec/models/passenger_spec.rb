require "rails_helper"

RSpec.describe Passenger, type: :model do
  describe "associations" do
    it { is_expected.to belong_to :booking }
  end

  describe "validates presence" do
    it { is_expected.to validate_presence_of(:firstname) }
    it { is_expected.to validate_presence_of(:lastname) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:telephone) }
    it { is_expected.to validate_presence_of(:nationality) }
  end
end
