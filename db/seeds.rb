puts "seeding..."
User.destroy_all
User.create!(email: "1@example.com", password: "123456", User_name: "1")
User.create!(email: "2@example.com", password: "123456", User_name: "2")
puts "done !"
