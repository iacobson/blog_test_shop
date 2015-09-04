class Order < ActiveRecord::Base
  has_many :product_orders
  has_many :products, through: :product_orders, source: :product
  belongs_to :user

  # ensure there is only one active order per user
  validates_uniqueness_of :status, conditions: -> { where(status: 'active') }, scope: :user_id

  # calculate shopping cart total
  def calculate_total
    self.products.pluck(:price).inject(:+)
  end

end
