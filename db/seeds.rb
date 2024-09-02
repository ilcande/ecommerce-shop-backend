# Clear existing records in a safe order
ProductConfiguration.destroy_all
StockLevel.destroy_all
Constraint.destroy_all
Option.destroy_all
Part.destroy_all
Product.destroy_all
User.destroy_all

puts "Cleared existing records."

# Create Products
bike = Product.create!(
  name: 'Mountain Bike',
  product_type: 'Bike',
  base_price: 500.00,
  image_url: 'https://images.pexels.com/photos/100582/pexels-photo-100582.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
)

bike_two = Product.create!(
  name: 'Road Bike',
  product_type: 'Bike',
  base_price: 700.00,
  image_url: 'https://images.pexels.com/photos/255934/pexels-photo-255934.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
)

bike_three = Product.create!(
  name: 'Fat Bike',
  product_type: 'Bike',
  base_price: 900.00,
  image_url: 'https://images.pexels.com/photos/1616566/pexels-photo-1616566.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
)

bike_four = Product.create!(
  name: 'Hybrid Bike',
  product_type: 'Bike',
  base_price: 600.00,
  image_url: 'https://images.pexels.com/photos/276517/pexels-photo-276517.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
)

puts "Created Products."

# Create Parts
suspension = Part.create!(name: 'Suspension', product_type: 'Bike')
frame = Part.create!(name: 'Frame', product_type: 'Bike')
wheels = Part.create!(name: 'Wheels', product_type: 'Bike')
rim_color = Part.create!(name: 'Rim Color', product_type: 'Bike')
chain = Part.create!(name: 'Chain', product_type: 'Bike')
frame_finish = Part.create!(name: 'Frame Finish', product_type: 'Bike')

puts "Created Parts."

# Create Options for Suspension
front_suspension = Option.create!(part: suspension, name: 'Front Suspension', price: 100.00)
rear_suspension = Option.create!(part: suspension, name: 'Rear Suspension', price: 120.00)
full_suspension = Option.create!(part: suspension, name: 'Full Suspension', price: 130.00)

# Create Options for Frame
diamond = Option.create!(part: frame, name: 'Diamond', price: 150.00)
step_through = Option.create!(part: frame, name: 'Step-through', price: 120.00)
cantilever = Option.create!(part: frame, name: 'Cantilever', price: 110.00)
recumbent = Option.create!(part: frame, name: 'Recumbent', price: 100.00)
monocoque = Option.create!(part: frame, name: 'Monocoque', price: 80.00)

# Create Options for Frame Finish
shiny = Option.create!(part: frame_finish, name: 'Shiny', price: 0.0)
matte = Option.create!(part: frame_finish, name: 'Matte', price: 0.0)
aluminium = Option.create!(part: frame_finish, name: 'Aluminium', price: 0.0)
carbonium = Option.create!(part: frame_finish, name: 'Carbonium', price: 0.0)


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
# Note: For frame finishes, we'll handle the dependency in the price calculation logic
[front_suspension, rear_suspension, full_suspension, diamond, step_through, cantilever, recumbent, monocoque, road_wheels, mountain_wheels, fat_bike_wheels, single_speed_chain, eight_speed_chain, red_rim, black_rim, blue_rim, shiny, matte, aluminium, carbonium].each do |option|
  ProductConfiguration.create!(product: bike, option: option)
  ProductConfiguration.create!(product: bike_two, option: option)
  ProductConfiguration.create!(product: bike_three, option: option)
  ProductConfiguration.create!(product: bike_four, option: option)
end

puts "Created Product Configurations."

# Create Stock Levels
[front_suspension, rear_suspension, full_suspension, diamond, step_through, cantilever, recumbent, monocoque, road_wheels, mountain_wheels, fat_bike_wheels, single_speed_chain, eight_speed_chain, red_rim, black_rim, blue_rim, shiny, matte, aluminium, carbonium].each do |option|
  StockLevel.create!(option: option, quantity: 10)
end

puts "Created Stock Levels."

# Create Constraints
# Example Constraints
# Note: These constraints will vary based on actual application requirements
Constraint.create!(
  part: wheels,
  option: mountain_wheels,
  constraint_part: suspension,
  constraint_option: full_suspension
)

Constraint.create!(
  part: wheels,
  option: fat_bike_wheels,
  constraint_part: rim_color,
  constraint_option: red_rim
)

puts "Created Constraints."

# Create Admin User
# Note: For simplicity, we'll create a single admin user
User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)
