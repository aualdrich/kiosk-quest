require "rails_helper"

RSpec.describe OrderPrepService do
  fixtures :menu_items, :stations

  describe "#call" do
    let(:order) do
      Order.new(
        subtotal_cents: 2_696,
        discount_cents: 270,
        total_cents: 2_426
      )
    end

    before do
      order.save!(validate: false)

      order.order_items.create!(
        menu_item: menu_items(:cheeseburger),
        quantity: 2
      )
      order.order_items.create!(
        menu_item: menu_items(:fries),
        quantity: 1
      )
      order.order_items.create!(
        menu_item: menu_items(:milkshake),
        quantity: 1
      )
    end

    it "assigns each order item line prep to the least loaded station" do
      result = described_class.new(order:).call

      expect(station_1 = Station.find(1)).to have_attributes(load_seconds: 180)
      expect(station_2 = Station.find(2)).to have_attributes(load_seconds: 135)
      expect(result).to have_attributes(success?: true, errors: [], estimated_prep_seconds: 180)
      expect(result.estimated_prep_seconds).to eq(180)
    end
  end
end
