require_relative 'lib/manabu/user'
require_relative 'lib/manabu/users'
require_relative 'lib/manabu/role'
require_relative 'lib/manabu/contact_types'
require_relative 'lib/manabu/connection/exam_channel'
require 'awesome_print'
# require_relative 'lib/manabu/class_group'
require 'pry'
client = Manabu::Client.new('admin', '123456', 'localhost', 9000, force_secure_connection: false)
# exam = Manabu::Exam.new(client, id: 5)
channel = Manabu::Connection::ExamChannel.new(client, 1)

channel.connect do |n|
  binding.pry
  puts n
end

loop do
  sleep 10
  puts 'NEXT'
end
puts 'as'
