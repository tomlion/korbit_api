module KorbitAPI
  module Resources
    class Bid < Hashie::Rash
      def inspect
        to_hash
      end
    end
  end
end