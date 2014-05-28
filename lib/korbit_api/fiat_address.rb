module KorbitAPI
  class FiatAddress < Hashie::Rash
    def inspect
      to_hash
    end
  end
end