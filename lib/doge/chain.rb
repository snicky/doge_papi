module DogePapi
  class DogeChain

    BASE_URI = 'http://dogechain.info/chain/Dogecoin/q'

    CALLS_RETURNING_INTEGER = [:getblockcount]
    CALLS_RETURNING_FLOAT   = [
                                :addressbalance       ,
                                :getdifficulty        ,
                                :getreceivedbyaddress ,
                                :getsentbyaddress     ,
                                :totalbc
                              ]
    CALLS_RETURNING_JSON    = [:transactions]

    def build_uri m, params
      list = params.join '/'
      URI.parse "#{BASE_URI}/#{m}/#{list}"
    end

    def fetch_uri uri
      uri.open.read
    end

    def method_missing m, *args, &block
      output = fetch_uri build_uri(m, args)
      output = output.to_i        if CALLS_RETURNING_INTEGER.include? m
      output = output.to_f        if CALLS_RETURNING_FLOAT.include? m
      output = JSON.parse(output) if CALLS_RETURNING_JSON.include? m
      output
    end
  end
end
