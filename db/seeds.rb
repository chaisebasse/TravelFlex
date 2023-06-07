puts "seeding..."
User.destroy_all
User.create!(email: "1@example.com", password: "123456", username: "1")
User.create!(email: "2@example.com", password: "123456", username: "2")
puts "done !"