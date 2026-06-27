# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

menu_items = [
  { name: "Cheeseburger", price_cents: 899, prep_seconds: 90 },
  { name: "Fries", price_cents: 399, prep_seconds: 60 },
  { name: "Milkshake", price_cents: 499, prep_seconds: 75 },
  { name: "Salad", price_cents: 699, prep_seconds: 45 },
  { name: "Nuggets", price_cents: 599, prep_seconds: 80 }
]

menu_items.each do |attributes|
  menu_item = MenuItem.find_or_initialize_by(name: attributes[:name])
  menu_item.assign_attributes(attributes)
  menu_item.save!
end

stations = [
  { name: "Station 1" },
  { name: "Station 2" }
]

stations.each do |attributes|
  station = Station.find_or_initialize_by(name: attributes[:name])
  station.assign_attributes(attributes)
  station.save!
end
