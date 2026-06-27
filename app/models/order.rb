class Order < ApplicationRecord
  has_many :order_items

  validates :subtotal_cents, presence: true, numericality: { greater_than: 0 }
  validates :discount_cents, presence: true, numericality: { greater_than: 0 }
  validates :total_cents, presence: true, numericality: { greater_than: 0 }
end
