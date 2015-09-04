class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.belongs_to :user, index: true
      t.string :name,       null: false
      t.integer :price,     null: false
      t.integer :stock,     null: false
      t.string :category,   null: false

      t.timestamps null: false
    end
  end
end
