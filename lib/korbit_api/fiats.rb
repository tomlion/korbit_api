module KorbitAPI
  class Fiats
    include Utils

    def initialize(client = nil)
      @client = client
    end

    def address
      @address ||= AddressRoute.new @client
    end

    def out(options = {})
      # Used as a stub for chaining user.fiats.out.cancel
      return @fiats_out ||= OutsRoute.new(@client) if options.empty?

      options[:currency] = 'krw'
      require_options options, :amount
      params = { currency: options[:currency], amount: options[:amount] }

      response = @client.protected_run :post, 'user/fiats/out',
                                       body: params
      Resources::Status.new JSON.parse(response.body)
    end

    # TODO: UNTESTED WITH IT RETURNING DATA (also, email??)
    def status(options = {})
      options[:currency] = 'krw'
      params = { currency: options[:currency] }
      params[:id] = options[:id] unless options[:id].nil?

      response = @client.protected_run :get, 'user/fiats/status',
                                       params: params

      JSON.parse(response.body).map do |transfer_status|
        TransferStatus.new transfer_status
      end
    end
  end

  # This is a stub class utilized to mimick the API url path as a ruby object
  class Fiats
    class AddressRoute
      include Utils

      def initialize(client = nil)
        @client = client
      end

      def assign
        currency = 'krw'
        response = @client.protected_run :post, 'user/fiats/address/assign',
                                         body: { currency: currency }
        Resources::FiatAddress.new JSON.parse(response.body)
      end

      def register(options = {})
        options[:currency] = 'krw'
        require_options options, :bank, :account

        params = { currency: options[:currency] }
        params[:bank] = options[:bank]
        params[:account] = options[:account]

        response = @client.protected_run :post, 'user/fiats/address/register',
                                         body: params
        Resources::Status.new JSON.parse(response.body)
      end
    end

    class OutsRoute
      include Utils

      def initialize(client = nil)
        @client = client
      end

      def cancel(options)
        options[:currency] = 'krw'
        require_options options, :id
        params = { currency: options[:currency], id: options[:id] }

        response = @client.protected_run :post, 'user/fiats/out/cancel',
                                         body: params
        Resources::Status.new JSON.parse(response.body)
      end
    end
  end
end

