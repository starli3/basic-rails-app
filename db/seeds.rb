require 'faker'

# Create 15 topics
topics = []    ##creating array of topics
15.times do    ## created 15 new fake topics
  topics << Topic.create(
    name: Faker::Lorem.words(rand(1..10)).join(" "), ##topic name is between 1-10 words, written in a sentence
    description: Faker::Lorem.paragraph(rand(1..4))  ##description written in a paragraph (between 1-4 paragraphs)
  )
end

rand(4..10).times do     ##every thing between lines 13 to 57 happens 4 to 10 times
  password = Faker::Lorem.characters(10)    ##password will be 10 characters
  u = User.new(                     ##new user
    name: Faker::Name.name,         ##new name
    email: Faker::Internet.email,   ##new email
    password: password,             ##new password
    password_confirmation: password)    ##new password confirmation
  u.skip_confirmation!
  u.save

  # Note: by calling `User.new` instead of `create`,
  # we create an instance of a user which isn't saved to the database.
  # The `skip_confirmation!` method sets the confirmation date
  # to avoid sending an email. The `save` method updates the database.

  rand(5..12).times do     ## each User loop you loop 5 to 12 times to create a Post by that user
    topic = topics.first # getting the first topic here
    p = u.posts.create(   ##create new post
      topic: topic,      ##hash syntax for creating a User, line above. You're creating a post at this point based on the relationship of the post to a user - u.post.create
      title: Faker::Lorem.words(rand(1..10)).join(" "),   ##create new title, 1-10 words
      body: Faker::Lorem.paragraphs(rand(1..4)).join("\n"))    ##create new body paragraph, 1-4 paragraphs
    # set the created_at to a time within the past year
    p.update_attribute(:created_at, Time.now - rand(600..31536000))

    p.update_rank
    topics.rotate! # add this line to move the first topic to the last, so that posts get assigned to different topics.

    # comments...

    ## rand(3..7).times    ##3 to 7 comments per post
    ##  p.comments.create(    ##starts in the context of post instead of user
    ##  user: u
       ## body: Faker::Lorem.paragraphs(rand(1..2)).join("\n"))

    rand(5..12).times do    
      c = u.comments.create(   
        post: p,     ##p is what you set post to earlier in the file
        body: Faker::Lorem.paragraphs(rand(1..4)).join("\n"))
    end
  end
end

u = User.new(
  name: 'Admin User',
  email: 'admin@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'admin')

u = User.new(
  name: 'Moderator User',
  email: 'moderator@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'moderator')

u = User.new(
  name: 'Member User',
  email: 'member@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save


puts "Seed finished"
puts "#{User.count} users created"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"



