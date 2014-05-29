module KorbitAPI
  class Constants
    def self.fetch(client)
      response = client.run :get, 'constants'
      Resources::Constant.new JSON.parse(response.body)
    end

    def self.version(client)
      response = client.run :get, 'version'
      Resources::Constant.new JSON.parse(response.body)
    end
  end
end