class OrdersController < ApplicationController
  before_action :set_order
  before_action :set_product, except: :update
  load_and_authorize_resource through: :current_user

  # add products to order
  def add_to
    @order.products << @product

    respond_to do |format|
      if @order.save
        format.html{redirect_to products_path(category: @product.category), notice: "Product added to cart"}
      else
        format.html{redirect_to products_path(category: @product.category), notice: "Something went wrong, please try again"}
      end
    end
  end

  # remove products from order
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

  # checkout the order and update the stocks
  def update
    respond_to do |format|
      if @order.check_stocks == "order_changed"
        format.html{redirect_to products_path, notice: "Please check your order! Products were updated according to the current stocks."}
      else
        @order.update_attributes(status: "checkout")
        format.html{redirect_to products_path, notice: "Your order will be shipped"}
      end
    end
  end

  # destroy the current order
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
