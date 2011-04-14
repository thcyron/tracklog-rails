require "bikelog/core_ext"

module Bikelog
  class Config
    class << self
      attr_accessor :password
    end
  end
end

# If not nil, a HTTP authentication will be performed at each
# request.  Only the entered password is checked against this value.
Bikelog::Config.password = "password"
