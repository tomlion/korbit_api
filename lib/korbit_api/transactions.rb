module KorbitAPI
  class Transactions
    def self.fetch(client, options = {})
      response = client.protected_run :get, 'user/transactions', params: options
      JSON.parse(response.body).map do |transaction|
        Resources::Transaction.new transaction
      end
    end
  end

  class PublicTransactions
    def self.fetch(client, options = {})
      response = client.run :get, 'transactions', params: options
      JSON.parse(response.body).map do |transaction|
        Resources::Transaction.new transaction
      end
    end
  end
end