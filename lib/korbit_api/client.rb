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
      @access_token  = options[:access_token]
      @refresh_token = options[:refresh_token]
      @version       = "v1"
    end

    def run(method, url_or_segment, options = {})
      options = {
          headers: {},
          params: {},
          body: {},
          plain_url: false
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
      Rails.logger.info "*" * 88
      Rails.logger.info "Running request"
      Rails.logger.info "*" * 88
      @hydra.run


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

    def version
      response = run :get, 'version'
      response.body
    end

    def user
      KorbitAPI::User.new(self)
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