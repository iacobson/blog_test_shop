FactoryGirl.define do
  factory :product do
    sequence(:name) {|n| "prod#{n}"}
    price 5
    stock 10
    category "electronics"
  end
end
