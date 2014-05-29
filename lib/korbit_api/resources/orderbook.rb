# TODO: Make this a smarter resource that assigns named acccessors for the three
# item array of price, the unfilled amount, and the number of orders.
module KorbitAPI
  module Resources
    class Orderbook < Hashie::Rash
      def inspect
        to_hash
      end
    end
  end
end