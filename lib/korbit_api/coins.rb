module KorbitAPI
  class Coins
    include Utils

    def initialize(client = nil)
      @client = client
    end

    def address
      @address ||= CoinsAddress.new @client
    end


    def out(options = {})
      # Used as a stub for chaining user.coins.out.cancel
      return @coins_out ||= CoinsOut.new(@client) if options.empty?

      options[:currency] = 'btc'
      require_options options, :amount, :address

      response = @client.protected_run :post, 'user/coins/out',
                                        body: {
                                          currency: options[:currency],
                                          amount: options[:amount],
                                          address: options[:address]
                                        }
      Transfer.new JSON.parse(response.body)
    end

    # TODO: UNTESTED WITH IT RETURNING DATA (also, email??)
    def status(options = {})
      options[:currency] = 'btc'

      params = { currency: options[:currency] }
      params[:id] = options[:id] if options[:id]
      params[:email] = options[:email] if options[:email]

      response = @client.protected_run :get, 'user/coins/status',
                                       params: params
      JSON.parse(response.body).map do |transfer_status|
        TransferStatus.new transfer_status
      end
    end

    def inspect
      {}
    end
  end

  # This is a stub class utilized to mimick the API url path as a ruby object
  class CoinsAddress
    def initialize(client = nil)
      @client = client
    end

    def assign
      currency = 'btc'
      response = @client.protected_run :post, 'user/coins/address/assign',
                                       body: { currency: currency }
      CryptoAddress.new JSON.parse(response.body)
    end
  end

  class CoinsOut
    include Utils

    def initialize(client = nil)
      @client = client
    end

    def cancel(options)
      options[:currency] = 'btc'
      require_options options, :id

      response = @client.protected_run :post, 'user/coins/out/cancel',
                                       body: {
                                           currency: options[:currency],
                                           id: options[:id]
                                       }
      Transfer.new JSON.parse(response.body)
    end
  end
end

