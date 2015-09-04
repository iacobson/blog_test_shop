class Product < ActiveRecord::Base
  has_many :product_orders
  has_many :orders, through: :product_orders

  #convert all categories to upper case
  before_save do
    self.category.upcase!
  end
end
