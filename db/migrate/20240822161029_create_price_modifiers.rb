class CreatePriceModifiers < ActiveRecord::Migration[7.1]
  def change
    create_table :price_modifiers do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :modifier_amount, precision: 10, scale: 2, null: false
      t.string :description
      t.timestamps
    end

    create_table :price_modifier_conditions do |t|
      t.references :price_modifier, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true
      t.timestamps
    end
  end
end
