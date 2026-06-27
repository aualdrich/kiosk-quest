class Station < ApplicationRecord
  has_many :station_queues, dependent: :destroy

  validates :name, presence: true

  def self.loads_for(order)
    order.station_queues.group(:station_id).sum(:load_seconds)
  end

  def self.by_highest_load_for(order)
    by_highest_load(loads_for(order))
  end

  def self.with_highest_load_for(order)
    with_highest_load(loads_for(order))
  end

  def self.with_lowest_load_for(order)
    with_lowest_load(loads_for(order))
  end

  def self.by_highest_load(station_loads)
    station_loads.sort_by do |station_id, load_seconds|
      [-load_seconds, station_id]
    end
  end

  def self.with_highest_load(station_loads)
    order(:id).max_by do |station|
      [station_loads.fetch(station.id, 0), -station.id]
    end
  end

  def self.with_lowest_load(station_loads)
    order(:id).min_by do |station|
      [station_loads.fetch(station.id, 0), station.id]
    end
  end
end
