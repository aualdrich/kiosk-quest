class CreateOrdersAndOrderItems < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.integer :subtotal_cents, null: false, default: 0
      t.integer :discount_cents, null: false, default: 0
      t.integer :total_cents, null: false, default: 0

      t.timestamps
    end

    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 0

      t.timestamps
    end
  end
end
