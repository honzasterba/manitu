require 'lib/manitu/common'

module Net
  class HTTPResponse
    def body
      "MOCK BODY"
    end
  end
end

module Manitu::Common
  
  @@returns = Net::HTTPSuccess.new("1", 200, "OK")
  
  def self.returns(val)
    @@returns = val
    @@raises = nil
  end
  
  def self.raises(exc)
    @@returns = nil
    @@raises = exc
  end
  
  def get_uri(*args)
    return @@returns if @@returns
    raise @@raises if @@raises
  end

end