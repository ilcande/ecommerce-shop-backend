FactoryBot.define do
  factory :option do
    association :part
    name { Faker::Commerce.color }
    price { Faker::Commerce.price(range: 10.0..100.0) }
    is_in_stock { true }
  end
end

