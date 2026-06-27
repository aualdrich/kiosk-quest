class StationQueue < ApplicationRecord
  belongs_to :station
  belongs_to :order
  belongs_to :order_item

  validates :station, presence: true
  validates :order, presence: true
  validates :order_item, presence: true
  validates :load_seconds, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
