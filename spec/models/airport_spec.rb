require 'rails_helper'

RSpec.describe Airport, type: :model do
  describe "#has_many" do
    it { is_expected.to have_many :flights }
  end
end
