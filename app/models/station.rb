class Station < ApplicationRecord
  validates :name, presence: true
  validates :load_seconds, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :by_lowest_load, -> { order(load_seconds: :asc, id: :asc) }
  scope :by_highest_load, -> { order(load_seconds: :desc, id: :asc) }
end
