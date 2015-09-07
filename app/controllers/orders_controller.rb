class OrdersController < ApplicationController
  before_action :set_order
  before_action :set_product, except: :update

  def add_to
    add = ProductOrder.new(order: @order, product: @product)

    respond_to do |format|
      if add.save
        format.html{redirect_to products_path(category: @product.category), notice: "Product added to cart"}
      else
        format.html{redirect_to products_path(category: @product.category), notice: "Something went wrong, please try again"}
      end
    end
  end

  def remove_from
    remove = ProductOrder.find_by(order: @order, product: @product)
    respond_to do |format|
      if remove.destroy
        format.html{redirect_to products_path(category: @product.category), notice: "Product removed from cart"}
      else
        format.html{redirect_to products_path(category: @product.category), notice: "Something went wrong, please try again"}
      end
    end
  end

  def update
    @order.check_stocks
    @order.update_attributes(status: "checkout")
    respond_to do |format|
      format.html{redirect_to products_path, notice: "Your order will be shipped"}
    end
  end

  def destroy
    respond_to do |format|
      if @order.destroy
        format.html{redirect_to products_path, notice: "Cart deleted"}
      else
        format.html{redirect_to products_path, notice: "Something went wrong, please try again"}
      end
    end
  end

  private
    def order_params
      params.require(:product).permit(:status)
    end

    def set_order
      @order = Order.find(params[:id])
    end

    def set_product
      @product = Product.find(params[:product]) if params[:product]
    end
end
