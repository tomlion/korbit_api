module KorbitAPI
  class Orderbook
    def self.fetch(client, options = {})
      response = client.run :get, 'orderbook', params: options
      Resources::Orderbook.new JSON.parse(response.body)
    end
  end
end