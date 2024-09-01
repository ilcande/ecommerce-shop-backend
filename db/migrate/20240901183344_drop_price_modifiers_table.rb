class DropPriceModifiersTable < ActiveRecord::Migration[7.1]
  def change
    # Drop the price_modifier_conditions table first to handle dependencies
    drop_table :price_modifier_conditions do |t|
      t.bigint :price_modifier_id, null: false
      t.bigint :option_id, null: false
      t.timestamps
    end

    # Drop the price_modifiers table next
    drop_table :price_modifiers do |t|
      t.bigint :product_id, null: false
      t.decimal :modifier_amount, precision: 10, scale: 2, null: false
      t.string :description
      t.timestamps
    end
  end
end
