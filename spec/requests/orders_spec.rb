require "rails_helper"

RSpec.describe "Orders" do
  fixtures :menu_items

  describe "POST /order" do
    it "creates an order and returns its totals" do
      expect do
        post "/order",
          params: {
            items: [
              { item_id: menu_items(:cheeseburger).id, qty: 2 },
              { item_id: menu_items(:fries).id, qty: 1 },
              { item_id: menu_items(:milkshake).id, qty: 1 }
            ]
          },
          as: :json
      end.to change(Order, :count).by(1)
        .and change(OrderItem, :count).by(3)

      expect(response).to have_http_status(:ok)
      expect(response_json).to eq(
        "subtotal_cents" => 2_696,
        "discount_cents" => 270,
        "total_cents" => 2_426
      )

      order = Order.includes(:order_items).last
      expect(order.order_items.order(:menu_item_id).pluck(:menu_item_id, :quantity)).to eq(
        [
          [menu_items(:cheeseburger).id, 2],
          [menu_items(:fries).id, 1],
          [menu_items(:milkshake).id, 1]
        ]
      )
    end

    it "returns a bad request with errors when the order is invalid" do
      expect do
        post "/order",
          params: {
            items: [
              { item_id: menu_items(:cheeseburger).id, qty: 0 }
            ]
          },
          as: :json
      end.not_to change(Order, :count)

      expect(response).to have_http_status(:bad_request)
      expect(response_errors).to include("Quantity must be greater than 0")
    end

    it "returns a bad request with errors when an item id does not exist" do
      expect do
        post "/order",
          params: {
            items: [
              { item_id: MenuItem.maximum(:id) + 1, qty: 1 }
            ]
          },
          as: :json
      end.not_to change(Order, :count)

      expect(response).to have_http_status(:bad_request)
      expect(response_errors).to include("Item ids must all exist")
    end
  end
end
