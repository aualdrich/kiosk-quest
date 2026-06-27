# TODO: add docstring describing the purpose of the class and its methods
class OrderPlacement
  include ActiveModel::Validations

  ItemInput = Struct.new(:item_id, :qty, keyword_init: true)
  Result = Struct.new(:success?, :errors, :order, :estimated_prep_seconds, :prep_schedule, keyword_init: true) do
    def subtotal_cents
      order&.subtotal_cents
    end

    def discount_cents
      order&.discount_cents
    end

    def total_cents
      order&.total_cents
    end
  end

  validate :item_ids_exist
  validate :order_items_are_valid
  validate :order_is_valid

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

    prep_result = nil
    ActiveRecord::Base.transaction do
      order.save!
      save_order_items
      prep_result = prepare_order
    end

    Result.new(
      success?: true,
      errors: [],
      order: order,
      estimated_prep_seconds: prep_result.estimated_prep_seconds,
      prep_schedule: prep_result.prep_schedule
    )
  end

  def order
    @order ||= build_order
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


  private

  def save_order_items
    order_items.each(&:save!)
  end

  def prepare_order
    OrderPrepService.new(order: order).call
  end

  def build_order
    Order.new(order_items: order_items).tap do |order|
      apply_pricing(order) if missing_item_ids.empty?
    end
  end

  def apply_pricing(order)
    pricing = OrderCalculation.new(order: order).call

    order.subtotal_cents = pricing.subtotal_cents
    order.discount_cents = pricing.discount_cents
    order.total_cents = pricing.total_cents
  end

  def invalid_result
    Result.new(
      success?: false,
      errors: errors.full_messages,
      order: nil,
      estimated_prep_seconds: nil,
      prep_schedule: nil
    )
  end

  def item_ids
    items.map(&:item_id)
  end

  def missing_item_ids
    @missing_item_ids ||= begin
      existing_item_ids = MenuItem.where(id: item_ids).pluck(:id).map(&:to_s)

      item_ids.map(&:to_s).uniq - existing_item_ids
    end
  end

  def item_ids_exist
    return if missing_item_ids.empty?

    errors.add(:item_ids, "must all exist")
  end

  def order_items_are_valid
    order

    order_items.each do |order_item|
      next if order_item.valid?

      order_item.errors.full_messages.each { |message| errors.add(:base, message) }
    end
  end

  def order_is_valid
    return if order.valid?

    order.errors.full_messages.each { |message| errors.add(:base, message) }
  end
end
