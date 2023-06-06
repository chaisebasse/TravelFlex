puts "seeding..."
User.create!(email: "1@example.com", password: "123456")
User.create!(email: "2@example.com", password: "123456")
puts "seeds done!"
