# TODO: Support a convience method of .cancel that maps out to:
# POST https://api.korbit.co.kr/v1/user/coins/out/cancel
module KorbitAPI
  class TransferStatus
    include Utils

    def initialize(data, client = nil)
      super data, nil, &blk
      @client = client
    end

    def inspect
      {}
    end
  end
end

