class CreateCartItems < ActiveRecord::Migration[7.1]
  def change
    create_table :cart_items do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, default: 1, null: false
      t.json :selections, default: {}

      t.timestamps
    end
  end
end
