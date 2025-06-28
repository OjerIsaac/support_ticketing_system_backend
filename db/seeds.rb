# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
users = [
  {
    email: "isaacojerumu@gmail.com",
    password: "password123",
    role: :agent,
    name: "Isaac Ojerumu"
  },
  {
    email: "ejiroebuka@gmail.com",
    password: "password123",
    role: :customer,
    name: "Ejiro Ebuka"
  },
  {
    email: "ejiroebuka+1@gmail.com",
    password: "password123",
    role: :customer,
    name: "Customer 2"
  }
]

users.each do |attrs|
  user = User.find_or_initialize_by(email: attrs[:email])
  if user.new_record?
    user.password = attrs[:password]
    user.password_confirmation = attrs[:password]
    user.role = attrs[:role]
    user.name = attrs[:name]
    user.save!
    puts "Created #{attrs[:role]}: #{attrs[:email]}"
  else
    puts "User already exists: #{attrs[:email]}"
  end
end
