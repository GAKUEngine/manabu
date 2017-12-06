require 'spec_helper'
require 'manabu/students'

describe Manabu::Students do

  context 'index' do
    it 'initializes, connects to the server, and checks status' do
      client = Manabu::Client.new('admin', 123456, 'localhost', 9000, force_secure_connection: false)
      students = Manabu::Students.new(client)
      expect(students.index).to be_kind_of(Hash)
    end
  end

  context 'register' do
    it 'initializes, connects to the server, and checks status' do
      client = Manabu::Client.new('admin', 123456, 'localhost', 9000, force_secure_connection: false)
      students = Manabu::Students.new(client)
      student_hash = { name: 'test', surname: 'test' }

      response = students.register(student_hash)
      expect(response).to be_kind_of(Hash)
      expect(response[:name]).to eq 'test'
    end

    it 'raise Manabu::Connection::Error::UnprocessableEntity when param is missing' do
      expect {
        client = Manabu::Client.new('admin', 123456, 'localhost', 9000, force_secure_connection: false)
        students = Manabu::Students.new(client)

        student_hash = { name: 'test' }
        response = students.register(student_hash)
      }.to raise_error(Manabu::Connection::Error::UnprocessableEntity)
    end

  end
end
