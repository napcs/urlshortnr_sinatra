require "sinatra/base"
require "redis"
require "./lib/url_store"

# Our connection to Redis.
REDIS = Redis.new
APP_PREFIX = "USHORT"

class UrlShortnr < Sinatra::Base

  # base url of server.
  def base_url
    "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end

  # GET /
  # Intro page with form
  get "/" do
    erb :index
  end

  # POST /  params[:url]
  # Store URL in Redis
  post "/" do
    url = params[:url]
    store = UrlStore.new REDIS, APP_PREFIX
    id = store.set url
    if id
      redirect "/u/#{id}/show"
    else
      erb :error
    end
  end

  # GET /u/1 
  # Redirect to the page specified
  get "/u/:id" do
    store = UrlStore.new REDIS, APP_PREFIX
    url_hash = store.get(params[:id])
    if url_hash["url"]
      redirect url_hash["url"]
    else
      erb :nothing
    end
  end

  # GET /u/1/show
  # Display the information about the redirection
  get "/u/:id/show" do
    store = UrlStore.new REDIS, APP_PREFIX
    url_hash = store.get(params[:id])
    if url_hash["url"]
      @url_hash = url_hash
      erb :show
    else
      erb :nothing
    end
  end

end
