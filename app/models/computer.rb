class Computer < ActiveRecord::Base
  has_one :product, as: :category, dependent: :destroy
end
