require 'spec_helper'
require 'manabu/syllabuses'

describe Manabu::Syllabuses do

  context 'index' do
    it 'initializes, connects to the server, and checks status' do
      client = Manabu::Client.new('admin', 123456, 'localhost', 9000, force_secure_connection: false)
      syllabuses = Manabu::Syllabuses.new(client)
      # setup
      expect(syllabuses.all).to be_kind_of(Array)
    end
  end

  context 'register' do
    it 'initializes, connects to the server, and checks status' do
      client = Manabu::Client.new('admin', 123456, 'localhost', 9000, force_secure_connection: false)
      syllabuses = Manabu::Syllabuses.new(client)
      syllabuse_hash = { code: 'test', name: 'test' }

      syllabus = syllabuses.register(syllabuse_hash)
      expect(syllabus).to be_kind_of(Manabu::Syllabus)
      expect(syllabus.code).to eq 'test'
    end

    it 'raise Manabu::Connection::Error::UnprocessableEntity when param is missing' do
      expect {
        client = Manabu::Client.new('admin', 123456, 'localhost', 9000, force_secure_connection: false)
        syllabuses = Manabu::Syllabuses.new(client)

        syllabuse_hash = { code: 'test' }
        response = syllabuses.register(syllabuse_hash)
      }.to raise_error(Manabu::Connection::Error::UnprocessableEntity)
    end

  end
end
