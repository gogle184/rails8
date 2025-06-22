# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create sample todos
Todo.find_or_create_by!(title: "Learn Rails 8") do |todo|
  todo.completed = false
end

Todo.find_or_create_by!(title: "Build a Todo API") do |todo|
  todo.completed = true
end

Todo.find_or_create_by!(title: "Write API documentation") do |todo|
  todo.completed = false
end

Todo.find_or_create_by!(title: "Deploy to production") do |todo|
  todo.completed = false
end

puts "Created #{Todo.count} todos"
