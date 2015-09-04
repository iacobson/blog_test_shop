require 'spec_helper'

describe ProductsController do

  describe "GET 'shop'" do
    it "returns http success" do
      get 'shop'
      response.should be_success
    end
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end
