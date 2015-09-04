class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user, index: true
      t.string :status, null: false, default: "active"

      t.timestamps null: false
    end
  end
end
