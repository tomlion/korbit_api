module KorbitAPI
  class Version
    def self.fetch(client, options = {})
      response = client.run :get, 'version'
      Resources::Version.new JSON.parse(response.body)
    end
  end
end