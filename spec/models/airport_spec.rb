require "rails_helper"

RSpec.describe Airport, type: :model do
  describe "associations" do
    it { is_expected.to have_many :flights }
  end

  describe "validates presence" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:continent) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:jurisdiction) }
    it { is_expected.to validate_presence_of(:state_and_code) }
    it { is_expected.to validate_presence_of(:rating) }
  end
end
