# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#

Product.destroy_all

straws = YAML.load_file(Rails.root.join("db", "straws.yml"))

straws.each do |product|
  Product.find_or_create_by!(product)
end

napkins = YAML.load_file(Rails.root.join("db", "napkins.yml"))

napkins.each do |product|
  Product.find_or_create_by!(product)
end

hot_cups = YAML.load_file(Rails.root.join("db", "hot_cups.yml"))

hot_cups.each do |product|
  Product.find_or_create_by!(product)
end

hot_cups_extras = YAML.load_file(Rails.root.join("db", "hot_cups_extras.yml"))

hot_cups_extras.each do |product|
  Product.find_or_create_by!(product)
end

cold_cups = YAML.load_file(Rails.root.join("db", "cold_cups.yml"))

cold_cups.each do |product|
  Product.find_or_create_by!(product)
end

pizza_boxes = YAML.load_file(Rails.root.join("db", "pizza_boxes.yml"))

pizza_boxes.each do |product|
  Product.find_or_create_by!(product)
end

kraft_food_containers = YAML.load_file(Rails.root.join("db", "kraft_food_containers.yml"))

kraft_food_containers.each do |product|
  Product.find_or_create_by!(product)
end

takeaway_extras = YAML.load_file(Rails.root.join("db", "takeaway_extras.yml"))

takeaway_extras.each do |product|
  Product.find_or_create_by!(product)
end

ice_cream_cups = YAML.load_file(Rails.root.join("db", "ice_cream_cups.yml"))

ice_cream_cups.each do |product|
  Product.find_or_create_by!(product)
end

User.find_or_create_by!(email: "foo@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.first_name = "Foo"
  user.last_name = "Bar"
end

User.all.each do |user|
  Product.all.each do |product|
    user.price_list_items.create!(product: product, price: 1.00)
  end
end
