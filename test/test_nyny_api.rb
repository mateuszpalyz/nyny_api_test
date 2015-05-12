require 'minitest/autorun'
require 'rack/test'
require 'rack/lint'
require 'nyny_api'
require  'database_cleaner'

class TestNynyApi < Minitest::Test
  include Rack::Test::Methods
  include NynyApi

  def app
    Rack::Lint.new(HackerNews.new)
  end

  def setup
    DatabaseCleaner.start
    Story.create!(title: 'Lorem ipsum', url: 'http://www.lipsum.com/')
  end

  def test_it_does_something_useful
    get '/'

    assert last_response.ok?
    assert_equal 'Hello from hackernews', last_response.body
  end

  def test_getting_list_of_all_submitted_stories
    Story.create!(title: 'Ipsum lorem', url: 'http://www.ipsum.com/')

    get '/stories'
    response = JSON.parse last_response.body

    assert last_response.ok?
    assert_equal 'Lorem ipsum', response.first['title']
    assert_equal 'Ipsum lorem', response.last['title']
  end

  def test_getting_a_single_story
    get '/stories/1'
    response = JSON.parse last_response.body

    assert last_response.ok?
    assert_equal 'Lorem ipsum', response['title']
  end

  def test_success_stories_post
    post '/stories', { title: 'Funny title', url: 'http://www.funny.com' }.to_json
    response = JSON.parse last_response.body

    assert_equal 201, last_response.status
    assert_equal 'Funny title', response['title']
  end

  def test_fail_stories_post
    post '/stories', { title: 'Funny title' }.to_json
    response = JSON.parse last_response.body

    assert_equal 422, last_response.status
    assert_equal "can't be blank", response['url'].first
  end

  def teardown
    DatabaseCleaner.clean
  end
end
