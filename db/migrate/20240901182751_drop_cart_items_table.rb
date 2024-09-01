class DropCartItemsTable < ActiveRecord::Migration[7.1]
  def change
    # Drop the cart_items table
    drop_table :cart_items do |t|
      t.bigint :product_id, null: false
      t.integer :quantity, default: 1, null: false
      t.json :selections, default: {}
      t.timestamps
    end
  end
end
