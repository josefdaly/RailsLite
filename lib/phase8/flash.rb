class Flash
  def initialize(req)
    @flash_messages = {}
    @messages_to_save = {}
    req.cookies.each do |cookie|
      if cookie.name == '_flash'
        @flash_messages = JSON.parse(cookie.value)
      end
    end
  end

  def [](key)
    @flash_messages[key]
  end

  def []=(key, val)
    @messages_to_save[key] = val
  end

  def now
    @flash_messages
  end

  def store_flash(res)
    res.cookies << WEBrick::Cookie.new('_flash', @messages_to_save.to_json)
  end
end
