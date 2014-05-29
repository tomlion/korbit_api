module KorbitAPI
  class Ticker
    def initialize(client = nil)
      @client = client
    end

    def simple
      response = @client.run :get, 'ticker'
      Resources::Ticker.new JSON.parse(response.body)
    end

    def detailed
      response = @client.run :get, 'ticker/detailed'
      Resources::Ticker.new JSON.parse(response.body)
    end
  end
end