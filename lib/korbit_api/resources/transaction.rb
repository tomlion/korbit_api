module KorbitAPI
  module Resources
    class Transaction < Hashie::Rash
      def inspect
        to_hash
      end
    end
  end
end