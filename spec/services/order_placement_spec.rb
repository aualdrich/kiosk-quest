require "rails_helper"

RSpec.describe OrderPlacement do
  fixtures :menu_items

  describe "#items" do
    it "exposes the provided items as item inputs" do
      order_placement = described_class.new(
        items: [
          { "item_id" => 1, "qty" => 2 },
          { "item_id" => 2, "qty" => 1 },
          { "item_id" => 3, "qty" => 1 }
        ]
      )

      expect(order_placement.items).to eq(
        [
          described_class::ItemInput.new(item_id: 1, qty: 2),
          described_class::ItemInput.new(item_id: 2, qty: 1),
          described_class::ItemInput.new(item_id: 3, qty: 1)
        ]
      )
    end
  end

  describe "#call" do
    it "creates an order and its order items" do
      order_placement = described_class.new(
        items: [
          { "item_id" => menu_items(:cheeseburger).id, "qty" => 2 },
          { "item_id" => menu_items(:fries).id, "qty" => 1 },
          { "item_id" => menu_items(:milkshake).id, "qty" => 1 }
        ]
      )

      expect { @result = order_placement.call }
        .to change(Order, :count).by(1)
        .and change(OrderItem, :count).by(3)

      expect(@result).to have_attributes(success?: true, errors: [], order: be_present)

      order = Order.includes(:order_items).find(@result.order.id)

      expect(order.order_items.order(:menu_item_id).pluck(:menu_item_id, :quantity)).to eq(
        [
          [menu_items(:cheeseburger).id, 2],
          [menu_items(:fries).id, 1],
          [menu_items(:milkshake).id, 1]
        ]
      )
    end

    it "returns errors without creating records when invalid" do
      order_placement = described_class.new(
        items: [
          { "item_id" => menu_items(:cheeseburger).id, "qty" => 0 }
        ]
      )

      expect { @result = order_placement.call }
        .to change(Order, :count).by(0)
        .and change(OrderItem, :count).by(0)

      expect(@result).to have_attributes(success?: false, order: nil)
      expect(@result.errors).to include("Quantity must be greater than 0")
    end
  end
end
