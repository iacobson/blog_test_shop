class ShoppingCart
  attr_reader :user, :params

  def initialize(user:, params:)
    @user = user
    @params = params
  end

  def product_categories
    @categories ||= Product.pluck(:category_type).uniq.sort
  end

  def products_by_category
    if params[:category] && product_categories.include?(params[:category])
      product_find(params[:category])
    else
      product_find(product_categories.first)
    end
  end

  def current_order
    @order ||= user.orders.where(status: "active").first_or_create
  end

  private

  def product_find(category)
    Product.where(category_type: category).includes(:category)
  end
end
