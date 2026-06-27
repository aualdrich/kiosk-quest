require "rails_helper"

RSpec.describe Station, type: :model do
  fixtures :menu_items, :stations

  subject(:station) do
    described_class.new(
      name: "Test Station"
    )
  end

  describe ".order(:id)" do
    it "returns the seeded stations in the expected order" do
      expect(Station.order(:id).pluck(:id, :name)).to eq(
        [
          [1, "Station 1"],
          [2, "Station 2"]
        ]
      )
    end
  end

  describe ".by_highest_load" do
    it "sorts station loads from highest to lowest and breaks ties by station id" do
      expect(described_class.by_highest_load({ 1 => 120, 2 => 180, 3 => 180 })).to eq(
        [
          [2, 180],
          [3, 180],
          [1, 120]
        ]
      )
    end
  end

  describe ".with_highest_load" do
    it "returns the station with the highest load and breaks ties by station id" do
      expect(described_class.with_highest_load({ 1 => 180, 2 => 60 })).to eq(stations(:station_1))
      expect(described_class.with_highest_load({ 1 => 60, 2 => 60 })).to eq(stations(:station_1))
    end
  end

  describe ".with_lowest_load" do
    it "returns the station with the lowest load and breaks ties by station id" do
      expect(described_class.with_lowest_load({ 1 => 180, 2 => 60 })).to eq(stations(:station_2))
      expect(described_class.with_lowest_load({ 1 => 60, 2 => 60 })).to eq(stations(:station_1))
    end
  end

  describe ".loads_for" do
    it "returns station loads for the given order" do
      order = Order.new(subtotal_cents: 899, discount_cents: 0, total_cents: 899)
      order.save!(validate: false)
      order_item = order.order_items.create!(menu_item: menu_items(:cheeseburger), quantity: 1)

      order.station_queues.create!(
        station: stations(:station_1),
        order_item: order_item,
        load_seconds: 90
      )

      expect(described_class.loads_for(order)).to eq({ 1 => 90 })
    end
  end

  describe ".by_highest_load_for" do
    it "returns station loads for the given order from highest to lowest" do
      order = Order.new(subtotal_cents: 2_197, discount_cents: 220, total_cents: 1_977)
      order.save!(validate: false)
      cheeseburger = order.order_items.create!(menu_item: menu_items(:cheeseburger), quantity: 1)
      fries = order.order_items.create!(menu_item: menu_items(:fries), quantity: 1)

      order.station_queues.create!(
        station: stations(:station_1),
        order_item: cheeseburger,
        load_seconds: 90
      )
      order.station_queues.create!(
        station: stations(:station_2),
        order_item: fries,
        load_seconds: 60
      )

      expect(described_class.by_highest_load_for(order)).to eq([[1, 90], [2, 60]])
    end
  end

  describe ".with_highest_load_for" do
    it "returns the station with the highest load for the given order" do
      order = Order.new(subtotal_cents: 2_197, discount_cents: 220, total_cents: 1_977)
      order.save!(validate: false)
      order_item = order.order_items.create!(menu_item: menu_items(:cheeseburger), quantity: 1)

      order.station_queues.create!(
        station: stations(:station_2),
        order_item: order_item,
        load_seconds: 90
      )

      expect(described_class.with_highest_load_for(order)).to eq(stations(:station_2))
    end
  end

  describe ".with_lowest_load_for" do
    it "returns the station with the lowest load for the given order" do
      order = Order.new(subtotal_cents: 2_197, discount_cents: 220, total_cents: 1_977)
      order.save!(validate: false)
      order_item = order.order_items.create!(menu_item: menu_items(:cheeseburger), quantity: 1)

      order.station_queues.create!(
        station: stations(:station_1),
        order_item: order_item,
        load_seconds: 90
      )

      expect(described_class.with_lowest_load_for(order)).to eq(stations(:station_2))
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:station_queues).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end
end
