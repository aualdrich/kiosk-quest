require "rails_helper"

RSpec.describe OrderPlacement do
  fixtures :menu_items, :stations

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
      # 2 x cheeseburger = 2 x 899 = 1_798
      # 1 x fries = 399
      # 1 x milkshake = 499
      # subtotal = 1_798 + 399 + 499 = 2_696
      # discount = 10% of 2_696 = 269.6, rounded to 270
      # total = 2_696 - 270 = 2_426
      # prep stations start at 0:
      #   cheeseburger line prep = 2 x 90 = 180 -> station 1
      #   fries line prep = 1 x 60 = 60 -> station 2
      #   milkshake line prep = 1 x 75 = 75 -> station 2 (60 < 180)
      # station loads end at 180 and 135, so estimated prep = 180 seconds
      expect(@result).to have_attributes(
        subtotal_cents: 2_696,
        discount_cents: 270,
        total_cents: 2_426,
        estimated_prep_seconds: 180,
        prep_schedule: [[1, 180], [2, 135]]
      )
      expect(@result.estimated_prep_seconds).to eq(180)
      expect(@result.prep_schedule).to eq([[1, 180], [2, 135]])

      order = Order.includes(:order_items).find(@result.order.id)

      expect(order.order_items.order(:menu_item_id).pluck(:menu_item_id, :quantity)).to eq(
        [
          [menu_items(:cheeseburger).id, 2],
          [menu_items(:fries).id, 1],
          [menu_items(:milkshake).id, 1]
        ]
      )

      expect(Station.find(1)).to have_attributes(load_seconds: 180)
      expect(Station.find(2)).to have_attributes(load_seconds: 135)
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

    it "returns errors without creating records when an item id does not exist" do
      order_placement = described_class.new(
        items: [
          { "item_id" => menu_items(:cheeseburger).id, "qty" => 1 },
          { "item_id" => MenuItem.maximum(:id) + 1, "qty" => 1 }
        ]
      )

      expect { @result = order_placement.call }
        .to change(Order, :count).by(0)
        .and change(OrderItem, :count).by(0)

      expect(@result).to have_attributes(success?: false, order: nil)
      expect(@result.errors).to eq(["Item ids must all exist"])
    end

    it "returns errors without creating records when no items are provided" do
      order_placement = described_class.new(items: [])

      expect { @result = order_placement.call }
        .to change(Order, :count).by(0)
        .and change(OrderItem, :count).by(0)

      expect(@result).to have_attributes(success?: false, order: nil)
      expect(@result.errors).to include("Order items can't be blank")
    end
  end
end
