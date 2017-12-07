module Manabu
  class Resource

    def initialize(**info)
      fill(info)
    end

    def fill(**info)
      self.class::FILL_ATTRS.each do |attr|
        instance_variable_set("@#{attr}", info.fetch(attr, instance_variable_get("@#{attr}")))
      end
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
