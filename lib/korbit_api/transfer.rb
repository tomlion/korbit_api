module KorbitAPI
  class Transfer < Hashie::Rash
    def inspect
      to_hash
    end
  end
end