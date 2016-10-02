require "rails_helper"

RSpec.describe Passenger, type: :model do
  describe "#belongs_to" do
    it { is_expected.to belong_to :booking }
  end

  describe "validates presence" do
    it { should validate_presence_of(:firstname) }
    it { should validate_presence_of(:lastname) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:telephone) }
    it { should validate_presence_of(:nationality) }
  end
end
