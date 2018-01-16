require_relative './resource'
require_relative './guardian'

module Manabu
  class Student < Resource
    attr_accessor :id, :surname, :name, :name_reading,
                    :surname_reading, :birth_date, :gender

    def fill(**info)
      @id = info.fetch(:id, @id)
      @surname = info.fetch(:surname, @surname)
      @name = info.fetch(:name, @name)
      @name_reading = info.fetch(:name_reading, @name_reading)
      @surname_reading = info.fetch(:surname_reading, @surname_reading)
      @birth_date = info.fetch(:birth_date, @birth_date)
      @gender = info.fetch(:gender, @gender)

      self
    end

    def set(**info)
      response = @client.patch("students/#{id}", info)
      fill(response)
    end

    def guardians
      response = @client.get("students/#{id}/guardians")
      response[:guardians].map do |guardian|
        Manabu::Guardian.new(@client, guardian)
      end
    end

    def courses
      response = @client.get("students/#{id}/courses")
      response[:courses].map do |course|
        Manabu::Course.new(@client, course)
      end
    end
  end
end
