module Manabu
  class Course < Resource
    FILL_ATTRS = %i( id code name ).freeze
    attr_accessor *FILL_ATTRS
  end
end
