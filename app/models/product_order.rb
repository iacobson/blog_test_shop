class ProductOrder < ActiveRecord::Base
  belongs_to :product
  belogns_to :order
end
