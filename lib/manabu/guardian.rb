require_relative './resource'

module Manabu
  class Guardian < Resource
    attr_accessor :id, :surname, :name, :name_reading, :surname_reading, :birth_date, :gender

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

  end
end
