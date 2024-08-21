FactoryBot.define do
  factory :part do
    name { Faker::Commerce.material }
    product_type { "bicycle" }
  end
end
