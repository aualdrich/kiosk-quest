class OrderPlacedBlueprint < Blueprinter::Base
  fields :subtotal_cents, :discount_cents, :total_cents, :estimated_prep_seconds, :prep_schedule
end
