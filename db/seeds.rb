# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Seed 20 clients
20.times do |i|
  User.create!(
    name: "Client #{i+5}",
    phone: "07110000#{i+1}",
    email: "client#{i+5}@example.com",
    password: 'password123',
    password_confirmation: 'password123',
    role: :client
  )
end

# Seed 7 riders with profiles
transport_modes = %w[foot bicycle motorbike]
7.times do |i|
  user = User.create!(
    name: "Rider #{i+5}",
    phone: "07220000#{i+1}",
    email: "rider#{i+5}@example.com",
    password: 'password123',
    password_confirmation: 'password123',
    role: :rider
  )
  user.create_rider_profile!(
    transport_mode: transport_modes.sample,
    license_plate: (i.even? ? "KDA#{1000+i}" : nil),
    available: [true, false].sample,
    current_lat: -1.28 + rand * 0.1,
    current_lng: 36.8 + rand * 0.1
  )
end

# Seed 10 menu categories, each with 10 menu items
10.times do |i|
  category = MenuCategory.create!(name: "Category #{i+1}")
  10.times do |j|
    MenuItem.create!(
      name: "Item #{j+1} in #{category.name}",
      price: rand(100..1000),
      image: "https://example.com/image#{i+1}_#{j+1}.jpg",
      description: "Delicious item #{j+1} in #{category.name}",
      menu_category: category
    )
  end
end
