require_relative 'lib/manabu/exam'
require_relative 'lib/manabu/client'
require 'pry'

client = Manabu::Client.new('admin', '123456', 'localhost', 9000, force_secure_connection: false)

exam = Manabu::Exam.new(client, id: 1)
grading = exam.grading
grading.start
binding.pry
puts 'asd'
