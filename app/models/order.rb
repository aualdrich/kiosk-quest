class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  validates :subtotal_cents, presence: true, numericality: { greater_than: 0 }
  validates :discount_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_cents, presence: true, numericality: { greater_than: 0 }
end
