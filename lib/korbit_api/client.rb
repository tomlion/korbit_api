module KorbitAPI
  class Client
    BASE_URL = "https://api.korbit.co.kr"
    TEST_URL = "https://api.korbit.co.kr:8080"

    attr_accessor :version
    attr_reader   :access_token, :refresh_token

    def initialize(options = {})
      options = {
        production: false # Should be true in published version of gem
      }.merge(options)

      @hydra         = Typhoeus::Hydra.hydra
      @base_url      = options[:production] ? BASE_URL : TEST_URL
      @client_id     = options[:client_id]     || KorbitAPI.config.client_id
      @client_secret = options[:client_secret] || KorbitAPI.config.client_secret
      @access_token  = options[:access_token]
      @refresh_token = options[:refresh_token]
      @version       = "v1"
    end

    def run(method, url_or_segment, options = {})
      options = {
          headers: {},
          params: {},
          body: {},
          plain_url: false,
          quiet_errors: false
      }.merge(options)
      headers = options[:headers]
      params  = options[:params]
      body    = options[:body]

      form_data = Addressable::URI.new
      form_data.query_values = body

      url = options[:plain_url] ? url_or_segment : build_url(url_or_segment)

      request = Typhoeus::Request.new url, method: method, headers: headers,
                                           params: params, body: form_data.query
      @hydra.queue request
      @hydra.run

      # If the query failed to an expiered OAuth token, fetch a new one and
      # rerun the request
      if request.response.code == 401
        refresh_oauth_token
        return run(method, url_or_segment, options)
      end

      # TODO: Flesh out errors + move to own method
      unless params[:quiet_errors]
        case request.response.code
          when 401
            auth_status = request.response.headers['WWW-Authenticate']
            if auth_status == 'Bearer error="invalid_token", error_description="The access token expired"'
              raise Error::OAuthAccessTokenExpiredError.new auth_status
            else
              raise Error::OAuthUnknownError.new auth_status
            end
          when 400
            raise Error::UnimplementedError.new request.response.headers
        end
      end

      request.response
    end

    def protected_run(method, url, options = {})
      # TODO: Raise some errors here if required vars not set
      options = {
          headers: {},
          params: {},
          body: {}
      }.merge(options)

      if method == :get
        options[:params][:access_token] = @access_token
        options[:params][:nonce] = nonce
      else
        options[:body][:access_token] = @access_token
        options[:body][:nonce] = nonce
      end

      run method, url, options
    end

    # TODO: Lots of copy pasta between refresh + direct. Refactor.
    def refresh_oauth_token
      # TODO: throw errors if client_id/client_secret/refresh_token isnt set
      body = {
          client_id: @client_id,
          client_secret: @client_secret,
          grant_type: 'refresh_token',
          refresh_token: @refresh_token
      }

      request = Typhoeus::Request.new build_url('oauth2/access_token'),
                                      method: :post, body: body
      @hydra.queue request
      @hydra.run

      # TODO: Make this more intelligent, prevent loops, and support quiet_errors
      unless request.response.code == 200
        raise Error::UnimplementedError.new request.response.headers
      end

      authentication = JSON.parse request.response.body
      @access_token  = authentication['access_token']
      @refresh_token = authentication['refresh_token']
      authentication
    end

    def direct_authentication(username, password)
      # TODO: throw errors if client_id/client_secret/refresh_token isnt set
      body = {
          client_id: @client_id,
          client_secret: @client_secret,
          grant_type: 'password',
          username: username,
          password: password
      }

      request = Typhoeus::Request.new build_url('oauth2/access_token'),
                                      method: :post, body: body
      @hydra.queue request
      @hydra.run

      # TODO: Make this more intelligent, prevent loops, and support quiet_errors
      unless request.response.code == 200
        raise Error::UnimplementedError.new request.response.headers
      end

      authentication = JSON.parse request.response.body
      @access_token  = authentication['access_token']
      @refresh_token = authentication['refresh_token']
      authentication
    end


    # Routes
    def user
      KorbitAPI::User.new(self)
    end

    def ticker
      @ticker ||= Ticker.new(self)
    end

    def orderbook(options = {})
      Orderbook.fetch(self, options)
    end

    def transactions(options = {})
      PublicTransactions.fetch(self, options)
    end

    def constants
      Constants.fetch(self)
    end

    def version
      Version.fetch(self)
    end

    def market
      @market ||= Market.new(self)
    end

    protected

    def build_url(segment)
      "#{@base_url}/#{@version}/#{segment}"
    end

    private

    def nonce
      (Time.now.to_f * 1000).floor
    end
  end
end
