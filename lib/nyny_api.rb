require "nyny_api/version"

module NynyApi
  require 'nyny'
  require 'database'
  require 'models/story'

  class HackerNews < NYNY::App

    get '/' do
      'Hello from hackernews'
    end

    get '/stories' do
      Story.all.to_json
    end

    get '/stories/:id' do
      Story.find(params[:id]).to_json
    end

    post '/stories' do
      story = Story.new(JSON.parse request.body.read)

      if story.save
        status 201
        story.to_json
      else
        status 422
        story.errors.to_json
      end
    end

    patch '/stories/:id' do
      story = Story.find(params[:id])

      if story.update(JSON.parse request.body.read)
        story.to_json
      else
        status 422
        story.errors.to_json
      end
    end

    get '/stories/:id/url' do
      redirect Story.find(params[:id]).url, 303
    end
  end
end
