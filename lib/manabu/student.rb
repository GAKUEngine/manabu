require_relative './resource'

module Manabu
  class Student < Resource
    attr_accessor :id, :surname, :name

    def initialize(**info)
      super(info)
    end

    def fill(**info)
      @id = info.fetch(:id, @id)
      @surname = info.fetch(:surname, @surname)
      @name = info.fetch(:name, @name)
      self
    end
  end
end
