class CreateStations < ActiveRecord::Migration[8.1]
  def change
    create_table :stations do |t|
      t.string :name, null: false
      t.integer :load_seconds, null: false, default: 0

      t.timestamps
    end
  end
end
