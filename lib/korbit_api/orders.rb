module KorbitAPI
  class Orders
    include Utils

    def initialize(client = nil)
      @client = client
    end

    def open(options = {})
      options[:offset] = 0
      options[:limit]  = 10

      response = @client.protected_run :get, 'user/orders/open',
                                       params: options

      JSON.parse(response.body).map do |order|
        Order.new order, @client
      end
    end

    # TODO: A lot more options checking needs to be implemented
    def buy(options)
      require_options options, :type

      response = @client.protected_run :post, 'user/orders/buy',
                                      body: options
      Order.new JSON.parse(response.body), @client
    end

    # TODO: Put in more options checking (make sure type is correct, and limit
    # is passed if type is set)
    def sell(options)
      require_options options, :type, :coin_amount

      response = @client.protected_run :post, 'user/orders/sell',
                                       body: options
      Order.new JSON.parse(response.body), @client
    end

    def cancel(options)
      require_options options, :id
      options[:id] = [options[:id]] unless options[:id].kind_of? Array

      response = @client.protected_run :post, 'user/orders/cancel',
                                       body: options

      JSON.parse(response.body).map do |order|
        Order.new order, @client
      end
    end
  end
end