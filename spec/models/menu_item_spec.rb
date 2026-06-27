require "rails_helper"

RSpec.describe MenuItem, type: :model do
  fixtures :menu_items

  subject(:menu_item) do
    described_class.new(
      name: "Test Burger",
      price_cents: 100,
      prep_seconds: 60
    )
  end

  describe ".order(:id)" do
    it "returns the seeded menu items in the expected order" do
      expect(
        MenuItem.order(:id).pluck(:id, :name, :price_cents, :prep_seconds)
      ).to eq(
        [
          [1, "Cheeseburger", 899, 90],
          [2, "Fries", 399, 60],
          [3, "Milkshake", 499, 75],
          [4, "Salad", 699, 45],
          [5, "Nuggets", 599, 80]
        ]
      )
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:price_cents) }
    it { is_expected.to validate_numericality_of(:price_cents).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:prep_seconds) }
    it { is_expected.to validate_numericality_of(:prep_seconds).is_greater_than(0) }
  end
end
