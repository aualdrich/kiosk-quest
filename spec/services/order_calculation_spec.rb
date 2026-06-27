require "rails_helper"

RSpec.describe OrderCalculation do
  fixtures :menu_items

  describe "constants" do
    it "defines the discount rule" do
      expect(described_class::DISCOUNT_PERCENT).to eq(0.10)
      expect(described_class::DISCOUNT_THRESHOLD_CENTS).to eq(2_000)
    end
  end

  describe "#call" do
    it "calculates subtotal, discount, and total from order items" do
      order = Order.new.tap do |order|
        order.order_items.build(menu_item: menu_items(:cheeseburger), quantity: 2)
        order.order_items.build(menu_item: menu_items(:fries), quantity: 1)
      end

      result = described_class.new(order:).call

      expect(result).to have_attributes(
        subtotal_cents: 2_197,
        discount_cents: 220,
        total_cents: 1_977
      )
    end

    it "does not apply a discount below the threshold" do
      order = Order.new.tap do |order|
        order.order_items.build(menu_item: menu_items(:fries), quantity: 1)
      end

      result = described_class.new(order:).call

      expect(result).to have_attributes(
        subtotal_cents: 399,
        discount_cents: 0,
        total_cents: 399
      )
    end
  end
end
