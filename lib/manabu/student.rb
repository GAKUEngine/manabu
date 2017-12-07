module Manabu
  class Student < Resource
    FILL_ATTRS =  %i( id surname name ).freeze
    attr_accessor *FILL_ATTRS
  end
end
