class CreateProductOrders < ActiveRecord::Migration
  def change
    create_table :product_orders do |t|
      t.belongs_to :product, index: true
      t.belongs_to :order, index: true

      t.timestamps null: false
    end
  end
end
