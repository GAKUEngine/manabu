module Manabu
  class EnrollmentStatus < Resource
    attr_reader :id, :active, :code, :immutable

    def fill(**info)
      @id = info.fetch(:id, @id)
      @code = info.fetch(:code, @code)
      @active = info.fetch(:active, @active)
      @immutable = info.fetch(:immutable, @immutable)
      self
    end

  end
end
