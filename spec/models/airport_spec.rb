require 'rails_helper'

RSpec.describe Airport, type: :model do
  describe "#has_many" do
    it { is_expected.to have_many :flights }
  end

  describe "validates presence" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:continent) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:jurisdiction) }
    it { should validate_presence_of(:state_and_code) }
    it { should validate_presence_of(:rating) }
  end
end
