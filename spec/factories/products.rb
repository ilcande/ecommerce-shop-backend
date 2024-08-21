FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    product_type { "bicycle" }
    base_price { Faker::Commerce.price(range: 100.0..1000.0) }
    image_url { Faker::Avatar.image }
  end
end
