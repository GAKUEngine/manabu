module Manabu
  class Student
    attr_accessor :id, :surname, :name

    def initialize(**info)
      fill(info)
    end

    def fill(**info)
      @id = info.fetch(:id, @id)
      @surname = info.fetch(:surname, @surname)
      @name = info.fetch(:name, @name)
      self
    end

    def _fill(var, sym, hash)
      var = hash[sym] if (hash.include?(sym) && !hash[sym].nil?)
    end

    def to_hash
      hash = {}
      instance_variables.each do |var|
        iv = instance_variable_get(var)
        hash[(var.to_s.delete("@")).to_sym] = iv if !iv.nil?
      end
      hash
    end
  end
end
