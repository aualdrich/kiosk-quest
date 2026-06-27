class OrderCalculation
  DISCOUNT_PERCENT = 0.10
  DISCOUNT_THRESHOLD_CENTS = 2_000

  Result = Struct.new(:subtotal_cents, :discount_cents, :total_cents, keyword_init: true)

  def initialize(order:)
    @order = order
  end

  def call
    subtotal_cents = order_items.sum { |order_item| order_item.menu_item.price_cents * order_item.quantity }
    discount_cents = subtotal_cents < DISCOUNT_THRESHOLD_CENTS ? 0 : (subtotal_cents * DISCOUNT_PERCENT).round

    Result.new(
      subtotal_cents: subtotal_cents,
      discount_cents: discount_cents,
      total_cents: subtotal_cents - discount_cents
    )
  end

  private

  attr_reader :order

  def order_items
    order.order_items
  end
end
