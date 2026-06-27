class MenuItem < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price_cents, presence: true, numericality: { greater_than: 0 }
  validates :prep_seconds, presence: true, numericality: { greater_than: 0 }
end
