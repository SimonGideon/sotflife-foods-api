class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total_price, null: false
      t.string :delivery_address, null: false
      t.integer :status, null: false, default: 0
      t.float :delivery_lat, null: false
      t.float :delivery_lng, null: false
      t.integer :rider_id, null: true

      t.timestamps
    end

    add_foreign_key :orders, :users, column: :rider_id
  end
end
