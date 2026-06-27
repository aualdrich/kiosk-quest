require "rails_helper"

RSpec.describe OrderItem, type: :model do
  fixtures :menu_items

  subject(:order_item) do
    described_class.new(
      order: Order.new(subtotal_cents: 899, discount_cents: 100, total_cents: 799),
      menu_item: menu_items(:cheeseburger),
      quantity: 1
    )
  end

  describe "associations" do
    it { is_expected.to belong_to(:order).required }
    it { is_expected.to belong_to(:menu_item).required }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:order) }
    it { is_expected.to validate_presence_of(:menu_item) }
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0) }
  end
end
