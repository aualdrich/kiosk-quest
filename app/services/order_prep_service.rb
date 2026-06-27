class OrderPrepService
  Result = Struct.new(:success?, :errors, :estimated_prep_seconds, :prep_schedule, keyword_init: true)

  def initialize(order:)
    @order = order
  end

  def call
    assign_station_load

    Result.new(
      success?: true,
      errors: [],
      estimated_prep_seconds: estimated_prep_seconds,
      prep_schedule: prep_schedule
    )
  end

  private

  attr_reader :order

  # Assign each order item to the least-loaded station for this order.
  def assign_station_load
    order.order_items.each do |order_item|
      line_prep = order_item.menu_item.prep_seconds * order_item.quantity
      station = Station.with_lowest_load_for(order)

      order.station_queues.create!(
        station: station,
        order_item: order_item,
        load_seconds: line_prep
      )
    end
  end

  def estimated_prep_seconds
    station_loads.values.max || 0
  end

  def prep_schedule
    Station.by_highest_load_for(order)
  end

  def station_loads
    Station.loads_for(order)
  end
end
