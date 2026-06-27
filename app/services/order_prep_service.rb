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

  # Assign the load of each order item to the station with the least load.
  def assign_station_load
    order.order_items.each do |order_item|
      line_prep = order_item.menu_item.prep_seconds * order_item.quantity
      station = Station.by_lowest_load.first

      station.load_seconds += line_prep
      station.save!
    end
  end

  def estimated_prep_seconds
    Station.maximum(:load_seconds)
  end

  def prep_schedule
    Station.by_highest_load.pluck(:id, :load_seconds)
  end
end
