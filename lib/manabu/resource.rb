module Manabu
  class Resource

    def initialize(client, **info)
      @client = client
      fill(info)
    end

    def fill(**info)
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
