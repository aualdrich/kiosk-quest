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
        .and change(StationQueue, :count).by(3)

      expect(response).to have_http_status(:ok)
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
      expect(response_json.keys).to eq(
        %w[
          subtotal_cents
          discount_cents
          total_cents
          estimated_prep_seconds
          prep_schedule
        ]
      )
      expect(response_json).to eq(
        "subtotal_cents" => 2_696,
        "discount_cents" => 270,
        "total_cents" => 2_426,
        "estimated_prep_seconds" => 180,
        "prep_schedule" => [
          [1, 180],
          [2, 135]
        ]
      )

      order = Order.includes(:order_items).last
      expect(order.order_items.order(:menu_item_id).pluck(:menu_item_id, :quantity)).to eq(
        [
          [menu_items(:cheeseburger).id, 2],
          [menu_items(:fries).id, 1],
          [menu_items(:milkshake).id, 1]
        ]
      )
      expect(order.station_queues.group(:station_id).sum(:load_seconds)).to eq(
        1 => 180,
        2 => 135
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

    it "returns a bad request with errors when quantity is nil" do
      expect do
        post "/order",
          params: {
            items: [
              { item_id: menu_items(:cheeseburger).id, qty: nil }
            ]
          },
          as: :json
      end.not_to change(Order, :count)

      expect(response).to have_http_status(:bad_request)
      expect(response_errors).to include("Quantity can't be blank")
    end

    it "returns a bad request with errors when quantity is omitted" do
      expect do
        post "/order",
          params: {
            items: [
              { item_id: menu_items(:cheeseburger).id }
            ]
          },
          as: :json
      end.not_to change(Order, :count)

      expect(response).to have_http_status(:bad_request)
      expect(response_errors).to include("Quantity can't be blank")
    end

    it "returns a bad request with errors when quantity is decimal" do
      expect do
        post "/order",
          params: {
            items: [
              { item_id: menu_items(:cheeseburger).id, qty: 1.5 }
            ]
          },
          as: :json
      end.not_to change(Order, :count)

      expect(response).to have_http_status(:bad_request)
      expect(response_errors).to include("Quantity must be an integer")
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
      expect(response_errors).to eq(["Item ids must all exist"])
    end

    it "returns a bad request with errors when items are omitted" do
      expect do
        post "/order", params: { order: {} }
      end.not_to change(Order, :count)

      expect(response).to have_http_status(:bad_request)
      expect(response_errors).to eq(["Order items can't be blank"])
    end
  end
end
