# TODO: Support a convience method of .cancel that maps out to:
# POST https://api.korbit.co.kr/v1/user/orders/cancel
module KorbitAPI
  class Order < Hashie::Rash

    def initialize(data, client = nil)
      super data, nil, &blk
      @client = client
    end

    # TODO: Currently if successful at canceling the order, this method will
    # append status="successful" to the order information, which is kind of
    # confusing.  Think of a better idea to handle it
    def cancel
      response = @client.user.orders.cancel id: self.id
      self.status = response.first.status
      self
    end

    def inspect
      to_hash
    end
  end
end

