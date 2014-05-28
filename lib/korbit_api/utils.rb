module KorbitAPI
  module Utils
    def require_options(options, *requirements)
      requirements.each do |requirement|
        if options[requirement].nil?
          raise "Missing required parameter: #{requirement}"
        end
      end
    end
  end
end