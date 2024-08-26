class AddOptionToConstraints < ActiveRecord::Migration[7.1]
  def change
    # Add a new column `option_id` to reference the option that triggers the constraint
    add_reference :constraints, :option, null: false, foreign_key: { to_table: :options }

    # Ensure the new column has an index for performance (if it doesn't already exist)
    unless index_exists?(:constraints, :option_id)
      add_index :constraints, :option_id
    end
  end
end
