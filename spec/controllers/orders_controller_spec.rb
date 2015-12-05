require 'spec_helper'

describe OrdersController do

  before do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @order1 = FactoryGirl.create(:order, user: @user1)
    @order2 = FactoryGirl.create(:order, user: @user2)
    @product1 = FactoryGirl.create(:product, stock: 10)
    @product2 = FactoryGirl.create(:product, stock: 2)
  end

  describe "PUT #add_to" do
    it "adds products to user order" do
      sign_in @user1

      expect {
        put :add_to, id: @order1, product: @product1
      }.to change(@order1.reload.products,:count).by(1)

      expect(response).to redirect_to(products_path(category: @product1.category))
    end

    it "adds 2 similar products to user order" do
      sign_in @user1

      expect {
        put :add_to, id: @order1, product: @product1
        put :add_to, id: @order1, product: @product1
      }.to change(@order1.reload.products,:count).by(2)
    end

    it "should not allow another user to add products to user order" do
      sign_in @user1

      expect {
        put :add_to, id: @order2, product: @product1
      }.not_to change(@order2.reload.products,:count)

      expect(response).to redirect_to(products_path)
    end
  end

  describe "PUT #remove_from" do
    before do
      @order1.products = [@product1, @product1, @product2, @product2, @product2]
      @order1.save
    end

    it "removes products from user order" do
      sign_in @user1

      expect {
        put :remove_from, id: @order1, product: @product1
      }.to change(@order1.reload.products,:count).by(-1)
      expect(@order1.products.to_a).to eql([@product1, @product2, @product2, @product2])

      expect(response).to redirect_to(products_path(category: @product1.category))
    end

    it "should not allow another user to remove products from user order" do
      sign_in @user2

      expect {
        put :remove_from, id: @order1, product: @product1
      }.not_to change(@order1.reload.products,:count)

      expect(response).to redirect_to(products_path)
    end
  end

  describe "PUT #update" do
    it "should update the products stocks on checkout" do
      @order1.products = [@product1, @product1, @product2, @product2, @product2]
      @order1.save

      put :update, id: @order1
      @product1.reload
      @product2.reload

      expect(@product1.stock).to eql() 

      expect {
        put :update, id: @order1
      }.to change(@product1.reload.stock,:count).by(-2)
      expect(@order1.products.to_a).to eql([@product1, @product2, @product2, @product2])

    end


  end

end
