require_relative 'client'
require_relative 'syllabus'

module Manabu
  class Syllabuses
    def initialize(client)
      @client = client
      @syllabuses = []
    end

    def all
      return @syllabuses if @syllabuses.any?
      # TODO format object
      response = @client.get('syllabuses')
      @syllabuses = response[:syllabuses].map do |syllabus|
        Manabu::Syllabus.new(@client, syllabus)
      end
    end

    def register(syllabus)
      new_syllabus = case syllabus
      when Manabu::Student
        register_syllabus_by_object(syllabus)
      when Hash
        register_syllabus_by_hash(syllabus)
      end
      new_syllabus.tap { |object| @syllabuses << object }
    end

    def register_syllabus_by_object(syllabus)
      res = @client.post('syllabuses', syllabus.to_hash)
      # TODO: handle errors
      syllabus.fill(res)
    end

    def register_syllabus_by_hash(syllabus)
      res = @client.post('syllabuses', syllabus)
      # TODO: handle errors
      Manabu::Syllabus.new(@client, res)
    end

  end
end
