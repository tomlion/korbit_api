module KorbitAPI
  module Resources
    class FiatAddress < Hashie::Rash
      def inspect
        to_hash
      end
    end
  end
end