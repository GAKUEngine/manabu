require_relative 'resource'
module Manabu
  class Role < Resource
    attr_reader :id, :name

    def fill(**info)
      @id = info.fetch(:id, @id)
      @name = info.fetch(:name, @name)
      self
    end

  end
end
