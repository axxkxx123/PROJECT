require 'digest'

# User class
class User
  attr_accessor :name, :email
  attr_reader :password

  def initialize(name, email, password)
    @name = name
    @password = hash_password(password)
    @email = email
    @rooms = []
  end

  # Method to enter a room
  def enter_room(room)
    unless @rooms.include?(room)
      @rooms << room
      room.add_user(self)
    end
  end

  # Method to send a message to a room
  def send_message(room, content)
    if @rooms.include?(room)
      message = Message.new(self, room, content)
      room.broadcast(message)
    else
      puts "You need to join the room first!"
    end
  end

  # Method to acknowledge a message
  def acknowledge_message(room, message)
    if @rooms.include?(room)
      puts "#{@name} acknowledged the message: '#{message.content}'"
    else
      puts "You cannot acknowledge messages from rooms you're not in."
    end
  end

  private

  # Hash the password using SHA256
  def hash_password(password)
    Digest::SHA256.hexdigest(password)
  end
end

# Room class
class Room
  attr_accessor :name, :description
  attr_reader :users

  def initialize(name, description)
    @name = name
    @description = description
    @users = []
  end

  # Add user to the room
  def add_user(user)
    @users << user unless @users.include?(user)
    puts "#{user.name} has entered the room '#{@name}'"
  end

  # Broadcast a message to all users in the room
  def broadcast(message)
    @users.each do |user|
      puts "#{user.name} received a new message: '#{message.content}'"
    end
  end
end

# Message class
class Message
  attr_accessor :user, :room, :content

  def initialize(user, room, content)
    @user = user
    @room = room
    @content = content
  end
end

# Example usage:
user1 = User.new("Alice", "alice@example.com", "password123")
user2 = User.new("Bob", "bob@example.com", "securePass!")

room = Room.new("General Chat", "A place to chat about general topics")

user1.enter_room(room)
user2.enter_room(room)

user1.send_message(room, "Hello everyone!")
user2.acknowledge_message(room, Message.new(user1, room, "Hello everyone!"))
