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
    let(:cheeseburgers) { order.order_items.first }
    let(:fries) { order.order_items.second }
    let(:milkshake) { order.order_items.third }

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
      expect { @result = described_class.new(order:).call }
        .to change(StationQueue, :count).by(3)

      station_queue_assignments = order.station_queues
        .joins(:order_item)
        .order("order_items.id")
        .map do |station_queue|
          {
            station_id: station_queue.station_id,
            order_item_id: station_queue.order_item_id,
            load_seconds: station_queue.load_seconds
          }
        end

      expect(station_queue_assignments).to eq(
        [
          { station_id: 1, order_item_id: cheeseburgers.id, load_seconds: 180 },
          { station_id: 2, order_item_id: fries.id, load_seconds: 60 },
          { station_id: 2, order_item_id: milkshake.id, load_seconds: 75 }
        ]
      )
      expect(@result).to have_attributes(
        success?: true,
        errors: [],
        estimated_prep_seconds: 180,
        prep_schedule: [[1, 180], [2, 135]]
      )
      expect(@result.estimated_prep_seconds).to eq(180)
      expect(@result.prep_schedule).to eq([[1, 180], [2, 135]])
    end

    it "ignores station queue rows from other orders" do
      other_order = Order.new(
        subtotal_cents: 899,
        discount_cents: 0,
        total_cents: 899
      )
      other_order.save!(validate: false)
      other_order_item = other_order.order_items.create!(
        menu_item: menu_items(:cheeseburger),
        quantity: 1
      )
      other_order.station_queues.create!(
        station: stations(:station_1),
        order_item: other_order_item,
        load_seconds: 10_000
      )

      result = described_class.new(order:).call

      expect(order.station_queues.order(:id).pluck(:station_id, :load_seconds)).to eq(
        [
          [1, 180],
          [2, 60],
          [2, 75]
        ]
      )
      expect(result).to have_attributes(
        estimated_prep_seconds: 180,
        prep_schedule: [[1, 180], [2, 135]]
      )
    end
  end
end
