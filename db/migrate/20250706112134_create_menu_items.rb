class CreateMenuItems < ActiveRecord::Migration[7.1]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.integer :price
      t.string :image
      t.string :description
      t.references :menu_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
