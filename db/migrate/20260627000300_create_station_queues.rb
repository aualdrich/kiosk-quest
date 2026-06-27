class CreateStationQueues < ActiveRecord::Migration[8.1]
  def change
    create_table :station_queues do |t|
      t.references :station, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.references :order_item, null: false, foreign_key: true, index: { unique: true }
      t.integer :load_seconds, null: false

      t.timestamps
    end

    remove_column :stations, :load_seconds, :integer, null: false, default: 0
  end
end
