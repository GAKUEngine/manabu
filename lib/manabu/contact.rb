require_relative './resource'
require_relative './contact_type'

module Manabu
  class Contact < Resource
    attr_accessor :id, :data, :contact_type

    def fill(**info)
      @id = info.fetch(:id, @id)
      @data = info.fetch(:data, @data)
      @contact_type =
        Manabu::ContactType.new(@client, info.fetch(:contact_type, {}))
      self
    end

  end
end
