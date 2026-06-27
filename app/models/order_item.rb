class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :menu_item

  validates :order, presence: true
  validates :menu_item, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
