class CreateShopDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_details do |t|
      t.string :name
      t.text :address
      t.float :latitude
      t.float :longitude
      t.float :delivery_radius_km
      t.string :contact_phone
      t.time :open_time
      t.time :close_time

      t.timestamps
    end
  end
end
