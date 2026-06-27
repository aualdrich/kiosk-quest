class Station < ApplicationRecord
  validates :name, presence: true
  validates :load_seconds, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
