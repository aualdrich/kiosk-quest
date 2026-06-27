require "rails_helper"

RSpec.describe StationQueue, type: :model do
  fixtures :menu_items, :stations

  subject(:station_queue) do
    order = Order.new(subtotal_cents: 899, discount_cents: 0, total_cents: 899)
    order_item = order.order_items.build(menu_item: menu_items(:cheeseburger), quantity: 1)

    described_class.new(
      station: stations(:station_1),
      order: order,
      order_item: order_item,
      load_seconds: 90
    )
  end

  describe "associations" do
    it { is_expected.to belong_to(:station).required }
    it { is_expected.to belong_to(:order).required }
    it { is_expected.to belong_to(:order_item).required }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:station) }
    it { is_expected.to validate_presence_of(:order) }
    it { is_expected.to validate_presence_of(:order_item) }
    it { is_expected.to validate_presence_of(:load_seconds) }
    it { is_expected.to validate_numericality_of(:load_seconds).only_integer.is_greater_than(0) }
  end
end
