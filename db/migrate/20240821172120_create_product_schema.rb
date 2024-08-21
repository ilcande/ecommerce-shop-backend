class CreateProductSchema < ActiveRecord::Migration[7.1]
  def change
    # Create Products table
    create_table :products do |t|
      t.string :name, null: false
      t.string :product_type, null: false
      t.decimal :base_price, precision: 10, scale: 2, null: false
      t.string :image_url
      t.timestamps
    end

    # Create Parts table
    create_table :parts do |t|
      t.string :name, null: false
      t.string :product_type, null: false
      t.timestamps
    end

    # Create Options table
    create_table :options do |t|
      t.references :part, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.boolean :is_in_stock, default: true
      t.timestamps
    end

    # Create Constraints table
    create_table :constraints do |t|
      t.references :part, null: false, foreign_key: { to_table: :parts }
      t.references :constraint_part, null: false, foreign_key: { to_table: :parts }
      t.references :constraint_option, null: false, foreign_key: { to_table: :options }
      t.timestamps
    end

    # Create ProductConfigurations table
    create_table :product_configurations do |t|
      t.references :product, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true
      t.timestamps
    end

    # Create StockLevels table
    create_table :stock_levels do |t|
      t.references :option, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 0
      t.boolean :is_in_stock, default: true
      t.timestamps
    end
  end
end
