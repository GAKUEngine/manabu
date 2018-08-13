require 'spec_helper'
require 'manabu/courses'

describe Manabu::Courses do

  context 'index' do
    it 'initializes, connects to the server, and checks status' do
      client = Manabu::Client.new('admin', '123456', 'localhost', 9000, force_secure_connection: false)
      courses = Manabu::Courses.new(client)
      expect(courses.all).to be_kind_of(Array)
    end
  end

  context 'register' do
    it 'initializes, connects to the server, and checks status' do
      client = Manabu::Client.new('admin', '123456', 'localhost', 9000, force_secure_connection: false)
      coursees = Manabu::Courses.new(client)
      course_hash = { code: 'test' }

      response = coursees.register(course_hash)
      expect(response).to be_kind_of(Manabu::Course)
      expect(response.code).to eq 'test'
    end

    it 'raise Manabu::Connection::Error::UnprocessableEntity when param is missing' do
      expect {
        client = Manabu::Client.new('admin', '123456', 'localhost', 9000, force_secure_connection: false)
        courses = Manabu::Courses.new(client)
        course_hash = {}
        response = courses.register(course_hash)
      }.to raise_error(Manabu::Connection::Error::UnprocessableEntity)
    end

  end
end
