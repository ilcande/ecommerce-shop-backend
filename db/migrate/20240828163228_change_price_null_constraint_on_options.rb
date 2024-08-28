class ChangePriceNullConstraintOnOptions < ActiveRecord::Migration[7.1]
  def up
    # Ensure all existing records have a default value for `price`
    Option.where(price: nil).update_all(price: 0.0)

    change_column_null :options, :price, false
  end

  def down
    change_column_null :options, :price, true
  end
end
