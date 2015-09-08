require 'spec_helper'

describe ProductsController do

  before do
    @user = FactoryGirl.create(:user)
    @admin = FactoryGirl.create(:user, admin: true)
    @product1 = FactoryGirl.create(:product, category: "aaa")
    @product2 = FactoryGirl.create(:product, category: "bbb")
    @product3 = FactoryGirl.create(:product, name: "Samsung Galaxy", price: 1000)
    @product4 = FactoryGirl.create(:product)
  end

  describe "GET #index" do
    before do
      sign_in @user
    end

    it "passes the products with first alpabetic category to he view" do
      get :index

      expect(assigns(:products)).to eq([@product1])
      expect(response).to render_template(:index)
    end

    it "passes the products with the requested category to the view" do
      get :index, {category: "BBB"}

      expect(assigns(:products)).to eq([@product2])
      expect(response).to render_template(:index)
    end

    it "generates an order for the user" do
      get :index
      expect(assigns(:order).user).to eq(@user)
    end
  end

  describe "POST #create" do
    it "should allow admin to create products" do
      sign_in @admin

      expect {
        post :create, product: {name: "Iphone 6", price: 1000, stock: 50, category: "electronics"}
      }.to change(Product,:count).by(1)

      expect(response).to redirect_to(products_path(category: "ELECTRONICS"))
    end

    it "should go back to form on failure" do
      sign_in @admin

      expect {
        post :create, product: {name: "", category: ""}
      }.not_to change(Product,:count)

      expect(response).to render_template(:new)
    end

    it "should not allow normal user to create products" do
      sign_in @user
      expect {
        post :create, product: {name: "Iphone 6", price: 1000, stock: 50, category: "electronics"}
      }.not_to change(Product,:count)
      expect(response).to redirect_to(products_path)
    end
  end

  describe "PUT #update" do
    it "should allow admin to update products" do
      sign_in @admin

      put :update, id: @product3, product: {name: "Iphone 6", price: 1000, stock: 50, category: "electronics"}
      @product3.reload
      expect(@product3.name).to eql("Iphone 6")
      expect(@product3.price).to eql(1000)
      expect(@product3.stock).to eql(50)
      expect(@product3.category).to eql("ELECTRONICS")

      expect(response).to redirect_to(products_path(category: "ELECTRONICS"))
    end

    it "should not allow incorrect updates" do
      sign_in @admin

      put :update, id: @product3, product: {name: "", price: ""}
      @product3.reload
      expect(@product3.name).to eql("Samsung Galaxy")
      expect(@product3.price).to eql(1000)

      expect(response).to render_template(:edit)
    end

    it "should not allow normal user to edit products" do
      sign_in @user
      put :update, id: @product3, product: {name: "Iphone 6", price: 30, stock: 50, category: "electronics"}
      @product3.reload
      expect(@product3.name).to eql("Samsung Galaxy")
      expect(@product3.price).to eql(1000)
      expect(response).to redirect_to(products_path)
    end
  end

  describe "DELETE #destroy" do
    it "should allow admin to delete products" do
      sign_in @admin

      expect {
        delete :destroy, id: @product4
      }.to change(Product,:count).by(-1)

      expect(response).to redirect_to(products_path(category: "ELECTRONICS"))
    end

    it "should not allow normar user to delete products" do
      sign_in @user
      expect {
        delete :destroy, id: @product4
      }.not_to change(Product,:count)
      expect(response).to redirect_to(products_path)
    end
  end
end
