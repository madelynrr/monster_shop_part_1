require 'rails_helper'

describe Coupon, type: :model do
  describe "validations" do
    it { should validate_presence_of :name}
    it { should validate_presence_of :code}
    it { should validate_presence_of :percentage}

    it {should validate_uniqueness_of :name}
    it {should validate_uniqueness_of :code}

    it {should validate_inclusion_of(:percentage).in_array((1..100).to_a)}
  end

  describe "relationships" do
    it { should belong_to :merchant}
  end
end
