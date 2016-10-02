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
end
