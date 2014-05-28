module KorbitAPI
  class Wallet < Hashie::Rash
    def initialize(data, client = nil)
      super data, nil, &blk
      @client = client
    end

    def self.get(client)
      response = client.protected_run :get, 'user/wallet'
      new JSON.parse(response.body), client
    end

    def inspect
      to_hash
    end
  end
end

