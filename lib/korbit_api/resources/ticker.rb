module KorbitAPI
  module Resources
    class Ticker < Hashie::Rash
      def inspect
        to_hash
      end
    end
  end
end