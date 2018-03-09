require_relative './resource'

module Manabu
  class Contact < Resource
    attr_accessor :id, :data, :contact_type_id

    def fill(**info)
      @id = info.fetch(:id, @id)
      @data = info.fetch(:data, @data)
      @contact_type_id = info.fetch(:contact_type_id, @contact_type_id)

      self
    end

  end
end
