# TODO: Flesh out the preference class and make it switch to ruby casing.
# TODO: Clean up the inspect for these classes
module KorbitAPI
  class User
    attr_reader :client, :info_fetched

    # Attributes of the user
    attr_accessor :email, :phone, :prefs
    attr_reader :name_checked_at, :name, :phone, :gender, :birthday

    def initialize(client)
      @client = client
      @info_fetched = false
    end

    def info
      response = @client.protected_run :get, 'user/info'
      @info_fetched = true
      info = JSON.parse(response.body)
      @email = info['email']
      @name  = info['name']
      @phone = info['phone']
      @gender = info['gender']
      @birthday = info['birthday']
      @name_checked_at = info['nameCheckedAt']
      @prefs = OpenStruct.new info['prefs']
      self
    end

    def transactions(options = {})
      Transactions.fetch(@client, options)
    end

    def fiats
      @fiats ||= Fiats.new(@client)
    end

    def email
      info if @info_fetched.nil?
      @email
    end

    def name
      info if @info_fetched.nil?
      @name
    end

    def phone
      info if @info_fetched.nil?
      @phone
    end

    def prefs
      info if @info_fetched.nil?
      @prefs
    end

    def birthday
      info if @info_fetched.nil?
      @birthday
    end

    def gender
      info if @info_fetched.nil?
      @gender
    end

    def name_checked_at
      info if @info_fetched.nil?
      @phone
    end

    def wallet
      @wallet ||= Wallet.get(@client)
    end

    def coins
      @coins ||= Coins.new(@client)
    end

    def orders
      @orders ||= Orders.new(@client)
    end
  end
end