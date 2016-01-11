class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :destroy]
  # cancancan authorization
  load_and_authorize_resource through: :current_user

  def index
    shopping_cart = ShoppingCart.new(user: current_user, params: params)
    @categories = shopping_cart.product_categories
    @products = shopping_cart.products_by_category
    @order = shopping_cart.current_order
  end

  def new
    @product = Product.new
  end

  def create
    @product = current_user.products.build(product_params)

    respond_to do |format|
      if @product.save
        format.html{redirect_to products_path(category: @product.category), notice: "Product created"}
      else
        format.html{render "new", notice: "Something went wrong, please try again"}
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html{redirect_to products_path(category: @product.category), notice: "Product updated"}
      else
        format.html{render "edit", notice: "Something went wrong, please try again"}
      end
    end
  end

  def destroy
    respond_to do |format|
      if @product.destroy
        format.html{redirect_to products_path(category: @product.category), notice: "Product deleted"}
      else
        format.html{redirect_to products_path(category: @product.category), notice: "Something went wrong, please try again"}
      end
    end
  end

  private
    def product_params
      params.require(:product).permit(:name, :price, :stock, :category)
    end

    def set_product
      @product = Product.find(params[:id])
    end
end
