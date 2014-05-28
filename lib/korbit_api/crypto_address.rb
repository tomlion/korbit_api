module KorbitAPI
  class CryptoAddress < Hashie::Rash
    def inspect
      to_hash
    end
  end
end

