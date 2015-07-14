require 'uri'
require 'byebug'
module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})

      @params = parse_www_encoded_form(req.query_string)
      @params = @params.merge(route_params)
      @params = @params.merge(parse_www_encoded_form(req.body))
    end

    def [](key)
      return @params[key] if key.is_a?(String)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      params = {}
      unless www_encoded_form.nil?
        URI.decode_www_form(www_encoded_form).each do |pair|
          keys = parse_key(pair.first)
          val = pair.last
          current = params
          keys.each_with_index do |key, idx|
            if idx == keys.length - 1
              current[key] = val
            else
              current[key] ||= {}
              current = current[key]
            end
          end
        end
      end
      params
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key = key.split("").map do |char|
        if char == ']' || char == '['
          ' '
        else
          char
        end
      end
      key.join.split
    end
  end
end
