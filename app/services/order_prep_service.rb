class OrderPrepService
  def initialize(order:)
    @order = order
  end

  def call
    assign_station_load
  end

  private

  attr_reader :order

  # Assign the load of each order item to the station with the least load.
  def assign_station_load
    order.order_items.each do |order_item|
      line_prep = order_item.menu_item.prep_seconds * order_item.quantity
      station = Station.order(:load_seconds, :id).first

      station.load_seconds += line_prep
      station.save!
    end
  end
end
