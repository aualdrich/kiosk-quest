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
    return invalid_result unless valid?

    ActiveRecord::Base.transaction do
      order.save!
      order_items.each(&:save!)
    end

    Result.new(success?: true, errors: [], order: order)
  end

  private

  def order
    # TODO: Calculate order totals from the requested menu items.
    @order ||= Order.new(subtotal_cents: 1, discount_cents: 1, total_cents: 1)
  end

  def order_items
    @order_items ||= items.map { |item| order_item(item) }
  end

  def order_item(item)
    # TODO: could we make this more future-proof by safely allowing new attributes to be added
    # without needing to add them here?
    order.order_items.build(
      menu_item_id: item.item_id,
      quantity: item.qty
    )
  end

  # TODO: we could probably make the service use active validations
  def valid?
    order.valid? & order_items.all?(&:valid?)
  end

  def invalid_result
    Result.new(success?: false, errors: errors, order: nil)
  end

  def errors
    order.errors.full_messages + order_items.flat_map { |order_item| order_item.errors.full_messages }
  end
end
