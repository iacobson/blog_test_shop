require 'spec_helper'

describe Order do
  before do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @user3 = FactoryGirl.create(:user)

    @product1 = FactoryGirl.create(:product, price: 5, stock: 10)
    @product2 = FactoryGirl.create(:product, price: 3, stock: 10)

    @order1 = FactoryGirl.create(:order, user: @user1, status: "active")
  end

  context "validations" do

    it "should not allow one user to have more than one active order" do
      expect{FactoryGirl.create(:order, user: @user1, status: "active")}.to raise_error
      expect(@user1.orders.size).to eql(1)
    end

    it "should allow different users to have active order" do
      order2 = FactoryGirl.create(:order, user: @user2, status: "active")
      order3 = FactoryGirl.create(:order, user: @user3, status: "active")

      expect(@user2.orders.size).to eql(1)
      expect(@user3.orders.size).to eql(1)
    end
  end

  context "total" do

    it "should calculate the order total" do
      @order1.products = [@product1, @product1, @product2]
      @order1.save

      expect(@order1.calculate_total).to eql(13)
    end
  end

  context "update stocks and update order" do

    it "should update stocks" do
      @order1.products = [@product1, @product1, @product2]
      @order1.save
      @order1.check_stocks

      expect(@order1.products.size).to eql(3)
      expect(@product1.reload.stock).to eql(8)
      expect(@product2.reload.stock).to eql(9)
    end

    it "should adjust the order depending on stock" do
      order2 = FactoryGirl.create(:order, user: @user2, status: "active")
      product3 = FactoryGirl.create(:product, price: 5, stock: 2)
      product4 = FactoryGirl.create(:product, price: 3, stock: 0)

      order2.products = [product3, product3, product3, product4, product4]
      order2.save
      order2.check_stocks
      order2.reload

      expect(order2.products.size).to eql(2)
      expect(order2.products.where(id: product4.id).size).to eql(0)
      expect(order2.products.where(id: product3.id).size).to eql(2)

      expect(product3.reload.stock).to eql(0)
      expect(product4.reload.stock).to eql(0)
    end
  end
end
