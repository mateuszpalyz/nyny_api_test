require "nyny_api/version"

module NynyApi
  require 'nyny'

  class HackerNews < NYNY::App
    get '/' do
      'Hello from hackernews'
    end
  end
end
