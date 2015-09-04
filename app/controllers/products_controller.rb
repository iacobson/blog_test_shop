class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :destroy]

  def index
    # display products depending on the category. Category is sent by frontend as param
    @categories = Product.pluck(:category).uniq.sort
    if params[:category]
      @products = Product.where(category: params[:category])
    else
      @products = Product.where(category: @categories[0])
    end

    # find or create the current active order for the user
    @order ||= current_user.orders.find_by(status: "active")
    if @order == nil
      @order = current_user.orders.create(status: "active")
    end
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
