# TODO: Organize requires
require 'typhoeus'
require 'hashie'
require 'rash'
require 'addressable/uri'

require 'korbit/resources/bid'
require 'korbit/resources/constant'
require 'korbit/resources/fiat_address'
require 'korbit/resources/orderbook'
require 'korbit/resources/status'
require 'korbit/resources/transaction'
require 'korbit/resources/version'

require 'korbit_api/client'
require 'korbit_api/coins'
require 'korbit_api/constants'
require 'korbit_api/crypto_address'
require 'korbit_api/fiat_address'
require 'korbit_api/errors'
require 'korbit_api/fiats'
require 'korbit_api/market'
require 'korbit_api/order'
require 'korbit_api/orderbook'
require 'korbit_api/orders'
require 'korbit_api/ticker'
require 'korbit_api/transactions'
require 'korbit_api/transfer'
require 'korbit_api/transfer_status'
require 'korbit_api/user'
require 'korbit_api/utils'
require 'korbit_api/version'
require 'korbit_api/wallet'

module KorbitAPI
  class << self
    def configure
      yield config
    end

    def config
      @config ||= OpenStruct.new
    end
  end
end