module KorbitAPI
  module Resources
    class Status < Hashie::Rash
      def inspect
        to_hash
      end
    end
  end
end