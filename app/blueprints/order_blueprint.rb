class OrderBlueprint < Blueprinter::Base
  fields :subtotal_cents, :discount_cents, :total_cents
end
