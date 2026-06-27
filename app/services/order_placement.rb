# TODO: add docstring describing the purpose of the class and its methods
class OrderPlacement
  ItemInput = Struct.new(:item_id, :qty, keyword_init: true)
  Result = Struct.new(:success?, :errors, :order, keyword_init: true)

  attr_reader :items

  # Expected items input:
  # [
  #   { "item_id" => 1, "qty" => 2 },
  #   { "item_id" => 2, "qty" => 1 },
  #   { "item_id" => 3, "qty" => 1 }
  # ]
  def initialize(items:)
    @items = items.map do |item|
      ItemInput.new(item_id: item.fetch("item_id"), qty: item.fetch("qty"))
    end
  end

  def call
    apply_pricing

    return invalid_result unless valid?

    ActiveRecord::Base.transaction do
      order.save!
      order_items.each(&:save!)
    end

    Result.new(success?: true, errors: [], order: order)
  end

  def order
    @order ||= Order.new(order_items: order_items)
  end

  def order_items
    return @order_items if defined?(@order_items)

    @order_items = items.map do |item|
      # TODO: could we make this more future-proof by safely allowing new attributes to be added
      # without needing to add them here?
      OrderItem.new(
        menu_item_id: item.item_id,
        quantity: item.qty
      )
    end
  end

  # TODO: we could probably make the service use active validations
  def valid?
    order.valid? & order_items.all?(&:valid?)
  end

  def apply_pricing
    pricing = OrderCalculation.new(order: order).call

    order.subtotal_cents = pricing.subtotal_cents
    order.discount_cents = pricing.discount_cents
    order.total_cents = pricing.total_cents
  end

  def invalid_result
    Result.new(success?: false, errors: errors, order: nil)
  end

  def errors
    order.errors.full_messages + order_items.flat_map { |order_item| order_item.errors.full_messages }
  end
end
