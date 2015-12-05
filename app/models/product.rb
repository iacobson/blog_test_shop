class Product < ActiveRecord::Base
  has_many :product_orders
  has_many :orders, through: :product_orders, source: :order

  validates_presence_of :name, :price, :stock, :category 

  #convert all categories to upper case
  before_save do
    self.category.upcase!
  end
end
