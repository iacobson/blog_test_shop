class Product < ActiveRecord::Base
  has_many :product_orders
  has_many :orders, through: :product_orders, source: :order
  belongs_to :category, polymorphic: true, dependent: :destroy

  validates_presence_of :price, :stock

  # #convert all categories to upper case
  # before_save do
  #   self.category.upcase!
  # end
end
