require "rails_helper"

RSpec.describe MenuItem, type: :model do
  fixtures :menu_items

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
end
