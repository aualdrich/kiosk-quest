class CreateMenuItems < ActiveRecord::Migration[8.1]
  def change
    create_table :menu_items do |t|
      t.string :name, null: false
      t.integer :price_cents, null: false
      t.integer :prep_seconds, null: false

      t.timestamps
    end

    add_index :menu_items, :name, unique: true
  end
end
