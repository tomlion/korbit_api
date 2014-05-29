module KorbitAPI
  class Market
    def initialize(client)
     @client = client
    end

    def bid(options = {})
      response = @client.run :get, 'market/bid', params: options
      Resources::Bid.new JSON.parse(response.body)
    end

    def ask(options = {})
      response = @client.run :get, 'market/ask', params: options
      Resources::Bid.new JSON.parse(response.body)
    end
  end
end