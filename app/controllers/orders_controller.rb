class OrdersController < ApplicationController
  def create
    result = OrderPlacement.new(items: order_items_params).call

    unless result.success?
      render json: { errors: result.errors }, status: :bad_request
      return
    end

    render json: OrderBlueprint.render(result.order)
  end

  private

  def order_items_params
    params.permit(items: [:item_id, :qty]).fetch(:items).map(&:to_h)
  end
end
