module KorbitAPI
  module Resources
    class Version < Hashie::Rash
      def inspect
        to_hash
      end
    end
  end
end