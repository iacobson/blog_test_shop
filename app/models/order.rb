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

  # count quantity for each product inside the cart and store it in a product => qty hash
  def items_counter
    cart = Hash.new(0)
    self.products.pluck(:id).each do |prod|
      cart[prod.to_s] += 1
    end
    return cart
  end

  # check stock for each item and adjust quantities in the cart if necessary
  def check_stocks
    items_counter.each do |prod, qty|
      # if the quantity inside the cart is greaterthan the one in the stock, adjust the quantity in the cart
      product = Product.find(prod)
      diff = product.stock - qty
      if diff < 0
        # make diff positive
        diff.abs.times do
          ProductOrder.find_by(order: self, product: prod).destroy
        end
        # remove all products from stock
        update_stocks(product, product.stock)
      else
        update_stocks(product, qty)
      end
    end
  end

  # update stock at checkout time
  def update_stocks(prod, qty)
    prod.update_attributes(stock: (prod.stock-qty))
  end
end
