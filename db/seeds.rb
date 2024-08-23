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

puts "Created Parts."

# Create Options
full_suspension = Option.create!(
  part: frame,
  name: 'Full Suspension',
  price: 130.00
)

diamond = Option.create!(
  part: frame,
  name: 'Diamond',
  price: 100.00
)

matte = Option.create!(
  part: frame,
  name: 'Matte',
  price: 30.00
)

shiny = Option.create!(
  part: frame,
  name: 'Shiny',
  price: 20.00
)

road_wheels = Option.create!(
  part: wheels,
  name: 'Road Wheels',
  price: 80.00
)

mountain_wheels = Option.create!(
  part: wheels,
  name: 'Mountain Wheels',
  price: 90.00
)

fat_bike_wheels = Option.create!(
  part: wheels,
  name: 'Fat Bike Wheels',
  price: 120.00
)

single_speed_chain = Option.create!(
  part: chain,
  name: 'Single-Speed Chain',
  price: 43.00
)

eight_speed_chain = Option.create!(
  part: chain,
  name: '8-Speed Chain',
  price: 50.00
)

puts "Created Options."

# Create Product Configurations
ProductConfiguration.create!(product: bike, option: full_suspension)
ProductConfiguration.create!(product: bike, option: diamond)
ProductConfiguration.create!(product: bike, option: matte)
ProductConfiguration.create!(product: bike, option: shiny)
ProductConfiguration.create!(product: bike, option: road_wheels)
ProductConfiguration.create!(product: bike, option: mountain_wheels)
ProductConfiguration.create!(product: bike, option: fat_bike_wheels)
ProductConfiguration.create!(product: bike, option: single_speed_chain)
ProductConfiguration.create!(product: bike, option: eight_speed_chain)

ProductConfiguration.create!(product: road_bike, option: full_suspension)
ProductConfiguration.create!(product: road_bike, option: diamond)
ProductConfiguration.create!(product: road_bike, option: matte)
ProductConfiguration.create!(product: road_bike, option: shiny)
ProductConfiguration.create!(product: road_bike, option: road_wheels)
ProductConfiguration.create!(product: road_bike, option: mountain_wheels)
ProductConfiguration.create!(product: road_bike, option: fat_bike_wheels)
ProductConfiguration.create!(product: road_bike, option: single_speed_chain)
ProductConfiguration.create!(product: road_bike, option: eight_speed_chain)

puts "Created Product Configurations."

# Create Stock Levels
StockLevel.create!(option: full_suspension, quantity: 10)
StockLevel.create!(option: diamond, quantity: 10)
StockLevel.create!(option: matte, quantity: 15)
StockLevel.create!(option: shiny, quantity: 5)
StockLevel.create!(option: road_wheels, quantity: 8)
StockLevel.create!(option: mountain_wheels, quantity: 10)
StockLevel.create!(option: fat_bike_wheels, quantity: 2)
StockLevel.create!(option: single_speed_chain, quantity: 20)
StockLevel.create!(option: eight_speed_chain, quantity: 12)

puts "Created Stock Levels."

# Create Constraints
Constraint.create!(
  part: frame,
  constraint_part: wheels,
  constraint_option: mountain_wheels
)

Constraint.create!(
  part: frame,
  constraint_part: wheels,
  constraint_option: fat_bike_wheels
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
    chain: single_speed_chain.id
  }
)

CartItem.create!(
  product: road_bike,
  quantity: 2,
  selections: {
    frame: diamond.id,
    wheels: road_wheels.id,
    chain: eight_speed_chain.id
  }
)

puts "Created Cart Items."
