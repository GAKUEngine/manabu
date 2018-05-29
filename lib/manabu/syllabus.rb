require_relative 'resource'
require_relative 'role'
module Manabu
  class Syllabus < Resource

    attr_reader :id, :name, :code

    def fill(**info)
      @id = info.fetch(:id, @id)
      @name = info.fetch(:name, @name)
      @code = info.fetch(:code, @code)
      self
    end

  end
end
