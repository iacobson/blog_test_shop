class AddPolymorphicRelationsToProduct < ActiveRecord::Migration
  def up
    remove_column :products, :category
    remove_column :products, :name
    add_column :products, :category_type, :string
    add_column :products, :category_id, :integer
    add_index :products, [:category_type, :category_id]
  end

  def down
    remove_index :products, column: [:category_type, :category_id]
    remove_column :products, :category_id, :integer
    remove_column :products, :category_type, :string
    add_coumn :products, :category, :string
    add_coumn :products, :name, :string
  end
end
