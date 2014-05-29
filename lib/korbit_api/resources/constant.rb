module KorbitAPI
  module Resources
    class Constant < Hashie::Rash
      def inspect
        to_hash
      end
    end
  end
end