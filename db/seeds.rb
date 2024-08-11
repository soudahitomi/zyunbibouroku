# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

olivia = User.find_or_create_by!(email: "olivia@example.com") do |user|
  user.name = "Olivia"
  user.password = "password"
end

james = User.find_or_create_by!(email: "james@example.com") do |user|
  user.name = "James"
  user.password = "password"
end

lucas = User.find_or_create_by!(email: "lucas@example.com") do |user|
  user.name = "Lucas"
  user.password = "password"
end

post1 = Post.find_or_create_by!(title: "やること") do |post|
  post.user = olivia
end

post2 = Post.find_or_create_by!(title: "買い物リスト") do |post|
  post.user = james
end

post3 = Post.find_or_create_by!(title: "勉強順") do |post|
  post.user = lucas
end

List.find_or_create_by!(content: "勉強順") do |list|
  list.post_id = post1.id
end

List.find_or_create_by!(content: "玉ねぎ、にんじん") do |list|
  list.post_id = post2.id
end

List.find_or_create_by!(content: "勉強順") do |list|
  list.post_id = post3.id
end