require 'uri'
require 'open-uri'

module DogeApi
  class DogeApi
    attr_accessor :api_key

    BASE_URI = URI.parse 'https://www.dogeapi.com/wow'

    CALLS_RETURNING_INTEGER = [:get_current_block]
    CALLS_RETURNING_FLOAT   = [
                                :get_balance          ,
                                :get_address_received ,
                                :get_difficulty       ,
                                :get_current_price
                              ]
    CALLS_RETURNING_JSON    = [:get_my_addresses]

    def initialize api_key
      @api_key = api_key
    end

    def build_uri m, args
      uri       = @base_uri
      params    = args.merge a: m, api_key: @api_key
      uri.query = URI.encode_www_form params
      uri
    end

    def fetch_uri uri
      uri.open.read
    end

    def method_missing m, args = {}, &block
      output = fetch_uri build_uri(m, args)
      if CALLS_RETURNING_JSON.include? m
        output = JSON.parse output
      else
        # Doge API wraps everything in double quotes,
        # so we need to get rid of them first.
        #
        output.tr! '"', ''
        output = output.to_i if CALLS_RETURNING_INTEGER.include? m
        output = output.to_f if CALLS_RETURNING_FLOAT.include? m
      end
      output
    end
  end
end
