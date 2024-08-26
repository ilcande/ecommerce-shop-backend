# Clear existing records in a safe order
CartItem.destroy_all
PriceModifier.destroy_all
ProductConfiguration.destroy_all
StockLevel.destroy_all
Constraint.destroy_all
Option.destroy_all
Part.destroy_all
Product.destroy_all

puts "Cleared existing records."

# Create Products
bike = Product.create!(
  name: 'Mountain Bike',
  product_type: 'Bike',
  base_price: 500.00,
  image_url: 'https://images.pexels.com/photos/100582/pexels-photo-100582.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
)

road_bike = Product.create!(
  name: 'Road Bike',
  product_type: 'Bike',
  base_price: 700.00,
  image_url: 'https://images.pexels.com/photos/26555452/pexels-photo-26555452/free-photo-of-road-bike-near-wall.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
)

puts "Created Products."

# Create Parts
frame = Part.create!(name: 'Frame', product_type: 'Bike')
wheels = Part.create!(name: 'Wheels', product_type: 'Bike')
chain = Part.create!(name: 'Chain', product_type: 'Bike')
rim_color = Part.create!(name: 'Rim Color', product_type: 'Bike')

puts "Created Parts."

# Create Options for Frame
full_suspension = Option.create!(part: frame, name: 'Full Suspension', price: 130.00)
diamond = Option.create!(part: frame, name: 'Diamond', price: 100.00)
matte = Option.create!(part: frame, name: 'Matte', price: 30.00)
shiny = Option.create!(part: frame, name: 'Shiny', price: 20.00)

# Create Options for Wheels
road_wheels = Option.create!(part: wheels, name: 'Road Wheels', price: 80.00)
mountain_wheels = Option.create!(part: wheels, name: 'Mountain Wheels', price: 90.00)
fat_bike_wheels = Option.create!(part: wheels, name: 'Fat Bike Wheels', price: 120.00)

# Create Options for Chain
single_speed_chain = Option.create!(part: chain, name: 'Single-Speed Chain', price: 43.00)
eight_speed_chain = Option.create!(part: chain, name: '8-Speed Chain', price: 50.00)

# Create Options for Rim Colors
red_rim = Option.create!(part: rim_color, name: 'Red', price: 20.00)
black_rim = Option.create!(part: rim_color, name: 'Black', price: 20.00)
blue_rim = Option.create!(part: rim_color, name: 'Blue', price: 20.00)

puts "Created Options."

# Create Product Configurations
[full_suspension, diamond, matte, shiny, road_wheels, mountain_wheels, fat_bike_wheels, single_speed_chain, eight_speed_chain].each do |option|
  ProductConfiguration.create!(product: bike, option: option)
  ProductConfiguration.create!(product: road_bike, option: option)
end

[rim_color].each do |part|
  part.options.each do |option|
    ProductConfiguration.create!(product: bike, option: option)
    ProductConfiguration.create!(product: road_bike, option: option)
  end
end

puts "Created Product Configurations."

# Create Stock Levels
[full_suspension, diamond, matte, shiny, road_wheels, mountain_wheels, fat_bike_wheels, single_speed_chain, eight_speed_chain, red_rim, black_rim, blue_rim].each do |option|
  StockLevel.create!(option: option, quantity: 10)
end

puts "Created Stock Levels."

# Create Constraints
# Restrict 'Mountain Wheels' to only work with 'Full Suspension' frames
Constraint.create!(
  part: wheels,
  option: mountain_wheels,
  constraint_part: frame,
  constraint_option: full_suspension
)

# Restrict 'Fat Bike Wheels' from using 'Red' rim color
Constraint.create!(
  part: wheels,
  option: fat_bike_wheels,
  constraint_part: rim_color,
  constraint_option: red_rim
)

puts "Created Constraints."

# Create Price Modifiers
PriceModifier.create!(
  product: bike,
  modifier_amount: 50.00,
  description: 'Price modifier for Full Suspension Frame'
)

PriceModifier.create!(
  product: road_bike,
  modifier_amount: 40.00,
  description: 'Price modifier for Diamond Frame'
)

puts "Created Price Modifiers."

# Create Cart Items (for testing purposes)
CartItem.create!(
  product: bike,
  quantity: 1,
  selections: {
    frame: full_suspension.id,
    wheels: mountain_wheels.id,
    chain: single_speed_chain.id,
    rim_color: red_rim.id
  }
)

CartItem.create!(
  product: road_bike,
  quantity: 2,
  selections: {
    frame: diamond.id,
    wheels: road_wheels.id,
    chain: eight_speed_chain.id,
    rim_color: black_rim.id
  }
)

puts "Created Cart Items."
