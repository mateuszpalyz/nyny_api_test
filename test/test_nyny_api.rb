require 'minitest/autorun'
require 'rack/test'
require 'rack/lint'
require 'nyny_api'

class TestNynyApi < Minitest::Test
  include Rack::Test::Methods
  include NynyApi

  def app
    Rack::Lint.new(HackerNews.new)
  end

  def test_it_does_something_useful
    get '/'

    assert last_response.ok?
    assert_equal 'Hello from hackernews', last_response.body
  end
end
