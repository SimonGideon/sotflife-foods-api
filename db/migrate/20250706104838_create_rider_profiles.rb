class CreateRiderProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :rider_profiles do |t|
      t.references :user, index: { unique: true }, null: false, foreign_key: true
      t.integer :transport_mode, null: false
      t.string :license_plate
      t.boolean :available, null: false, default: true
      t.float :current_lat, null: false
      t.float :current_lng, null: false

      t.timestamps
    end
  end
end
