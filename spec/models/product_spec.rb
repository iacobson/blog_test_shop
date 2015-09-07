require 'spec_helper'

describe Product do
  it "should convert category to uppercase" do
    product = FactoryGirl.create(:product, category: "electronics")

    expect(product.category).to eql("ELECTRONICS")
  end

end
