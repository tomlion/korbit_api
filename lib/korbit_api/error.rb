module KorbitAPI
  module Error
    class KorbitAPIError < StandardError; end

    class OAuthAccessTokenExpiredError < KorbitAPIError; end
    class OAuthUnknownError < KorbitAPIError; end
    class UnimplementedError < KorbitAPIError; end
  end
end