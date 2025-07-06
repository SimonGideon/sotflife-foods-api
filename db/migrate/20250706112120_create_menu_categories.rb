class CreateMenuCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :menu_categories do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
  end
end
