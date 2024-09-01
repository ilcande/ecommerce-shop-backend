class DropCustomersAndJwtDenylistTables < ActiveRecord::Migration[7.1]
  def change
    # Drop the customers table
    drop_table :customers do |t|
      t.string :email, default: "", null: false
      t.string :encrypted_password, default: "", null: false
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.timestamps
    end

    # Drop the jwt_denylist table
    drop_table :jwt_denylist do |t|
      t.string :jti, null: false
      t.datetime :exp, null: false
      t.timestamps
    end
  end
end
